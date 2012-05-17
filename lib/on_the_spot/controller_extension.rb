module OnTheSpot
  module ControllerExtension

    def self.included(base)
      base.extend ClassMethods
    end

    # if this method is called inside a controller, the edit-on-the-spot
    # controller action is added that will allow to edit fields in place
    module ClassMethods
      def can_edit_on_the_spot(check_acces_method=nil)
        define_method :update_attribute_on_the_spot do
          klass, field, id = params[:id].split('__')
          select_data = params[:select_array]
          display_method = params[:display_method]

          object = klass.camelize.constantize.find(id)

          is_allowed = check_acces_method.present? ? self.send(check_acces_method, object, field) : true

          if is_allowed
            if object.update_attributes(field => params[:value])
              if select_data.nil?
                field_or_method = if display_method.present?
                                    object.send(display_method)
                                  else
                                    value = object.send(field).to_s
                                    params[:raw] ? value : CGI::escapeHTML(value)
                                  end
                render :text => field_or_method
              else
                parsed_data = JSON.parse(select_data.gsub("'", '"').gsub('\"', "'"))
                render :text => parsed_data[object.send(field).to_s]
              end
            else
              render :text => object.errors.full_messages.join("\n"), :status => 422
            end
          else
            render :text => t('on_the_spot.access_not_allowed'), :status => 422
          end
        end

        define_method :get_attribute_on_the_spot do
          klass, field, id = params[:id].split('__')

          object = klass.camelize.constantize.find(id)

          is_allowed = check_acces_method.present? ? self.send(check_acces_method, object, field) : true

          if is_allowed
            render :text => object.send(field)
          else
            render :text => t('on_the_spot.access_not_allowed'), :status => 422
          end
        end
      end
    end
    
  end
end