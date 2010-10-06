require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'on_the_spot/on_the_spot_helpers'

require 'action_controller'

describe "OnTheSpot" do
  describe "Helpers" do
    before(:each) do

      class TestClass < ActionView::Base
        include OnTheSpot::Helpers
      end

      @tester = TestClass.new
      @test_array_nr  = [[1,"abc"], [2, "def"], [3, "ghi"]]
      @test_array_str = [["key", "value"], ["key2", "value2"]]
    end

    context "lookup values from array" do
      it "should find value abc for key 1" do
        @tester.lookup_display_value(@test_array_nr, 1).should == 'abc'
      end

      it "should find value <value2> for key key2" do
        @tester.lookup_display_value(@test_array_str, 'key2').should == 'value2'
      end

      it "should return an empty string if key does not exist" do
        @tester.lookup_display_value(@test_array_str, 'key1').should == ''
      end

    end

    context "convert array to json" do
      it "should convert correctly" do
        @tester.convert_array_to_json(@test_array_nr, 1).should == "{ '1':'abc', '2':'def', '3':'ghi', 'selected':'1'}"
      end
    end

    context "creating a simple edit-field" do
      before(:each) do
        @dummy = mock()
        @dummy.stub!(:content).and_return('test')
        @dummy.stub!(:id).and_return('123')
        @tester.should_receive(:t).with('on_the_spot.ok').and_return("ok")
        @tester.should_receive(:t).with('on_the_spot.cancel').and_return("cancel")
        @tester.should_receive(:t).with('on_the_spot.tooltip').and_return("tooltip")
        @tester.should_receive(:url_for).and_return('/bla')
        @result = @tester.on_the_spot_edit @dummy, :content
      end
      it "should make the correct html" do
        @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
      end
    end
  end
end
