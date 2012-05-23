require 'spec_helper'


require 'generator_spec/test_case'
require 'generators/on_the_spot/install/install_generator'

require 'rspec/mocks'

describe OnTheSpot::Generators::InstallGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path("../../tmp", __FILE__)


  context "in rails 3.0" do
    context "with no arguments" do
      before(:each) do
        Rails.stub(:version) { '3.0.8' }
        prepare_destination
        run_generator
      end

      it "stubs the version correctly" do
        Rails.version[0..2].should == "3.0"
      end

      it "stubs the version correctly" do
        test_version = (Rails.version[0..2].to_f >= 3.1)
        test_version.should be_false
      end

      ['on_the_spot.js', 'jquery.jeditable.mini.js', 'jquery.jeditable.checkbox.js'].each do |js_file|
        it "copies #{js_file} to the correct folder" do
          assert_file "public/javascripts/#{js_file}"
        end
      end

      it "copies on_the_spot.css to the correct folder" do
        assert_file "public/stylesheets/on_the_spot.css"
      end
    end
  end

  context "in rails 3.1" do
    context "with no arguments" do
      before(:each) do
        Rails.stub(:version) { '3.1.0' }
        prepare_destination
        run_generator
      end

      ['on_the_spot.js', 'jquery.jeditable.mini.js', 'jquery.jeditable.checkbox.js'].each do |js_file|
        it "does not copy #{js_file}" do
          assert_no_file "public/javascripts/#{js_file}"
        end
      end

      it "does not copy on_the_spot.css" do
        assert_no_file "public/stylesheets/on_the_spot.css"
      end
    end
  end

end