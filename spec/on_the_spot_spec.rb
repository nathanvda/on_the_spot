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
      @test_array_nr  = [[1,"abc"], [2, "def"], [3, "ghi"], [4, "Freddy's Nightmare"]]
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

      it "can handle single quotes normally" do
        @tester.lookup_display_value(@test_array_nr, 4).should == "Freddy's Nightmare"
      end

    end

    context "convert array to json" do
      it "should convert correctly" do
        @tester.convert_array_to_json(@test_array_nr, 1).should == "{ '1':'abc', '2':'def', '3':'ghi', '4':'Freddy\\'s Nightmare', 'selected':'1'}"
      end

      it "convert an array containing an item with single quotes to valid JSON" do
        test_array_with_single_quote = [[1, "tree"], [2, "bike"], [3, "John's hat"]]
        json_str = @tester.convert_array_to_json(test_array_with_single_quote, 1)
        json_str.should == "{ '1':'tree', '2':'bike', '3':'John\\'s hat', 'selected':'1'}"
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

        it "makes the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for an edit-field with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :selected => true
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-selected=\"true\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for an edit-field and overrule display-text" do
          @result = @tester.on_the_spot_edit @dummy, :content, :display_text => 'jediknight'
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">jediknight</span>"
        end

        it "makes the correct html for an edit-field and use the display-method as string" do
          @dummy.should_receive(:changed_content).and_return("test-changed")
          @tester.should_receive(:url_for).with({:action => 'get_attribute_on_the_spot'}).and_return('/bla-again')

          @result = @tester.on_the_spot_edit @dummy, :content, :display_method => 'changed_content'
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-display-method=\"changed_content\" data-loadurl=\"/bla-again\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test-changed</span>"
        end

        it "makes the correct html for an edit-field and use the display-method (as symbol)" do
          @dummy.should_receive(:changed_content).and_return("test-changed")
          @tester.should_receive(:url_for).with({:action => 'get_attribute_on_the_spot'}).and_return('/bla-again')

          @result = @tester.on_the_spot_edit @dummy, :content, :display_method => :changed_content
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-display-method=\"changed_content\" data-loadurl=\"/bla-again\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test-changed</span>"
        end


        it "makes the correct html for a text-area" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-columns=\"40\" data-edittype=\"textarea\" data-ok=\"ok\" data-rows=\"5\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for a text-area with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea, :selected => true
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-columns=\"40\" data-edittype=\"textarea\" data-ok=\"ok\" data-rows=\"5\" data-selected=\"true\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for a select-box" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :data => [['test', 'This a test'], ['prod', 'Pure Production'], ['QA', 'Quality Assurance']]
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-ok=\"ok\" data-select=\"{ 'test':'This a test', 'prod':'Pure Production', 'QA':'Quality Assurance', 'selected':'test'}\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">This a test</span>"
        end

        it "makes the correct html for a checkbox" do
          @dummy.stub!(:content).and_return(true)
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :checkbox
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"checkbox\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">true</span>"
        end

        it "makes the correct html for an edit-field with a callback" do
          @result = @tester.on_the_spot_edit @dummy, :content, :callback => 'testCallback(value, settings);'
          @result.should == "<span class=\"on_the_spot_editing\" data-callback=\"testCallback(value, settings);\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for an edit-field with an onblur action" do
          @result = @tester.on_the_spot_edit @dummy, :content, :onblur => 'submit'
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-onblur=\"submit\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        it "makes the correct html for an edit-field with a loadurl" do
          @result = @tester.on_the_spot_edit @dummy, :content, :loadurl => '/load/data'
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-loadurl=\"/load/data\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end

        context "a select-box with a loadurl" do
          it "makea the correct html (and not look up the value)" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data'
            @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-loadurl=\"/load/data\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
          end

          it "use the display-text preferrably" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data', :display_text => 'ninja'
            @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-edittype=\"select\" data-loadurl=\"/load/data\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">ninja</span>"
          end
        end
      end

      context "with explicit route" do
        before(:each) do
          @tester.should_receive(:url_for).with({:action => 'update_it_otherwise'}).and_return('/bla')
        end

        it "make the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content, :url => {:action => 'update_it_otherwise' }
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla\" id=\"r_spec/mocks/mock__content__123\">test</span>"
        end
      end

      context "with raw parameter" do
        before(:each) do
          @tester.should_receive(:url_for).with({:action => 'update_attribute_on_the_spot', :raw => true}).and_return('/bla?raw=true')
        end

        it "supports raw html" do
          @dummy.stub!(:content).and_return('<b>test</b>')
          @result = @tester.on_the_spot_edit @dummy, :content, :raw => true
          @result.should == "<span class=\"on_the_spot_editing\" data-cancel=\"cancel\" data-ok=\"ok\" data-tooltip=\"tooltip\" data-url=\"/bla?raw=true\" id=\"r_spec/mocks/mock__content__123\"><b>test</b></span>"
        end
      end
    end
  end
end
