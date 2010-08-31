module OnTheSpot
  class ControllerExtension

    def self.included(base)
      base.extend ClassMethods
    end

    # if this method is called inside a controller, the edit-on-the-spot
    # controller action is added that will allow to edit fields in place
    module ClassMethods
      def can_edit_on_the_spot
        define_method :update_attribute_on_the_spot do
          klass, field, id = id_string.split('__')
          object = klass.camelize.constantize.find(id)
          object.update_attribute(field, params[:value])
          render :text => CGI::escapeHTML(object.send(field).to_s)
        end
      end
    end
    
  end
end