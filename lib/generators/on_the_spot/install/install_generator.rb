module OnTheSpot
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc "This generator installs jEditable and some glue javascript (if rails < 3.1) and installs the locale"

      #def download_jeditable
      #  # Downloading latest jEditable
      #  get "http://www.appelsiini.net/download/jquery.jeditable.mini.js", "public/javascripts/jquery.jeditable.mini.js"
      #end

      def copy_javascripts
        if ::Rails.version[0..2].to_f >= 3.1
          #puts "The javascripts do not need to be installed since Rails 3.1"
        else
          copy_file "../../../../../app/assets/javascripts/on_the_spot_code.js", "public/javascripts/on_the_spot.js"
          copy_file "../../../../../app/assets/javascripts/jquery.jeditable.mini.js", "public/javascripts/jquery.jeditable.mini.js"
          copy_file "../../../../../app/assets/javascripts/jquery.jeditable.checkbox.js", "public/javascripts/jquery.jeditable.checkbox.js"
          copy_file "../../../../../app/assets/css/on_the_spot.css", "public/stylesheets/on_the_spot.css"
        end
      end

      def copy_locales
        copy_file "on_the_spot.en.yml", "config/locales/on_the_spot.en.yml"
        copy_file "on_the_spot.fr.yml", "config/locales/on_the_spot.fr.yml"
      end

    end
  end
end