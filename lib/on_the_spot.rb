require 'on_the_spot/controller_extension'
require 'on_the_spot/on_the_spot_helpers'

module OnTheSpot
  class Engine < ::Rails::Engine

    config.before_initialize do
      if config.action_view.javascript_expansions
        config.action_view.javascript_expansions[:on_the_spot] = %w(jquery.jeditable.mini.js on_the_spot_code)
      end
    end

    # configure our plugin on boot. other extension points such
    # as configuration, rake tasks, etc, are also available
    initializer "on_the_spot.initialize" do |app|
      if Rails::VERSION::MAJOR >= 6
        ActiveSupport.on_load(:action_controller) do
          ActionController::Base.send :include, OnTheSpot::ControllerExtension
        end
      else
        ActionController::Base.send :include, OnTheSpot::ControllerExtension
      end
      ActionView::Base.send :include, OnTheSpot::Helpers
    end

  end
end
