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

    context "the helpers" do
      before(:each) do
        @dummy = mock()
        @dummy.stub!(:content).and_return('test')
        @dummy.stub!(:id).and_return('123')
        @tester.should_receive(:t).with('on_the_spot.ok').and_return("ok")
        @tester.should_receive(:t).with('on_the_spot.cancel').and_return("cancel")
        @tester.should_receive(:t).with('on_the_spot.tooltip').and_return("tooltip")
      end

      context "with standard route" do
        before(:each) do
          @tester.should_receive(:url_for).with({:action => 'update_attribute_on_the_spot'}).and_return('/bla')
        end

        it "should make the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end
        
        it "should make the correct html for an edit-field with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :selected => true
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-selected=\"true\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "should make the correct html for an edit-field and overrule display-text" do
          @result = @tester.on_the_spot_edit @dummy, :content, :display_text => 'jediknight'
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">jediknight</span>"
        end

        it "should make the correct html for a text-area" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-columns=\"40\" data-edittype=\"textarea\" data-ok=\"ok\" data-rows=\"5\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end
        
        it "should make the correct html for a text-area with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea, :selected => true
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-columns=\"40\" data-edittype=\"textarea\" data-ok=\"ok\" data-rows=\"5\" data-selected=\"true\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "should make the correct html for a select-box" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :data => [['test', 'This a test'], ['prod', 'Pure Production'], ['QA', 'Quality Assurance']]
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-ok=\"ok\" data-select=\"{ 'test':'This a test', 'prod':'Pure Production', 'QA':'Quality Assurance', 'selected':'test'}\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">This a test</span>"
        end
        
        it "should make the correct html for an edit-field with a callback" do
          @result = @tester.on_the_spot_edit @dummy, :content, :callback => 'testCallback(value, settings);'
          @result.should == "<span class=\"on_the_spot_editing\" data-callback=\"testCallback(value, settings);\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end



        context "a select-box with a loadurl" do
          it "should make the correct html (and not look up the value)" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data'
            @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-loadurl=\"/load/data\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
          end

          it "should use the display-text preferrably" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data', :display_text => 'ninja'
            @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-loadurl=\"/load/data\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">ninja</span>"
          end
        end
      end

      context "with explicit route" do
        before(:each) do
          @tester.should_receive(:url_for).with({:action => 'update_it_otherwise'}).and_return('/bla')
        end

        it "should make the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content, :url => {:action => 'update_it_otherwise' }
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

      end
    end
  end
end
