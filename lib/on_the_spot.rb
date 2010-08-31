module OnTheSpot
  class Railtie < ::Rails::Railtie
    config.generators.integration_tool :rspec
    config.generators.test_framework   :rspec

    rake_tasks do
      load "on_the_spot/tasks/on_the_spot.rake"
    end
  end
end