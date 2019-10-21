module OnTheSpot
  module ControllerExtension

    def self.included(base)
      base.extend ClassMethods
    end

    # if this method is called inside a controller, the edit-on-the-spot
    # controller action is added that will allow to edit fields in place
    module ClassMethods
      def can_edit_on_the_spot(options_or_check_access_method=nil)
        check_access_method = options_or_check_access_method.is_a?(Hash) ? options_or_check_access_method[:is_allowed] : options_or_check_access_method
        on_success_method   = options_or_check_access_method.is_a?(Hash) ? options_or_check_access_method[:on_success] : nil

        define_method :update_attribute_on_the_spot do
          klass_name, field, id = params[:id].split('__')
          select_data = params[:select_array]
          display_method = params[:display_method]

          klass = klass_name.camelize.constantize
          object = klass.find(id)

          is_allowed = check_access_method.present? ? self.send(check_access_method, object, field) : true

          if is_allowed
            saved = if klass.attribute_names.include?(field)
                      object.update_attributes(field => params[:value])
                    else
                      # calculated attribute?
                      object.send("#{field}=", params[:value])
                      object.save
                    end
            if saved
              if on_success_method.present?
                self.send(on_success_method, object, field, params[:value])
              end
              if select_data.nil?
                field_or_method = if display_method.present?
                                    object.send(display_method)
                                  else
                                    value = object.send(field).to_s
                                    params[:raw] ? value : CGI::escapeHTML(value)
                                  end
                render :plain => field_or_method
              else
                parsed_data = JSON.parse(select_data.gsub("'", '"').gsub('\"', "'"))
                render :plain => parsed_data[object.send(field).to_s]
              end
            else
              render :plain => object.errors.full_messages.join("\n"), :status => 422
            end
          else
            render :plain => t('on_the_spot.access_not_allowed'), :status => 422
          end
        end

        define_method :get_attribute_on_the_spot do
          klass_name, field, id = params[:id].split('__')

          object = klass_name.camelize.constantize.find(id)

          is_allowed = check_access_method.present? ? self.send(check_access_method, object, field) : true

          if is_allowed
            render :plain => object.send(field)
          else
            render :plain => t('on_the_spot.access_not_allowed'), :status => 422
          end
        end
      end
    end
    
  end
end