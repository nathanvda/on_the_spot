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

      it "copies on_the_spot.js to the correct folder" do
        assert_file "public/javascripts/on_the_spot.js"
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

      it "does not copy on_the_spot.js" do
        assert_no_file "public/javascripts/on_the_spot.js"
      end
    end
  end

end