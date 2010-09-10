module OnTheSpot
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc "This generator installs jEditable and some glue javascript"

      def download_jeditable
        # Downloading latest jQuery
        get "http://www.appelsiini.net/download/jquery.jeditable.mini.js", "public/javascripts/jquery.jeditable.mini.js"
      end

      def copy_glue_javascript
        # !!!!! TO DO: check this -> how do a copy?
        copy_file "on_the_spot.js", "public/javascripts/on_the_spot.js"
        copy_file "on_the_spot.en.yml", "config/locales/on_the_spot.en.yml"
      end

    end
  end
end