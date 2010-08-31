module OnTheSpot
  class Railtie < ::Rails::Railtie
    config.generators.integration_tool :rspec
    config.generators.test_framework   :rspec

    # configure our plugin on boot. other extension points such
    # as configuration, rake tasks, etc, are also available
    initializer "on_the_spot.initialize" do |app|

      ActionController::Base.send :include, OnTheSpot::ControllerExtension
      ActionController::Base.helpers OnTheSpot::Helpers

    end

    rake_tasks do
      load "on_the_spot/tasks/on_the_spot.rake"
    end
  end
end