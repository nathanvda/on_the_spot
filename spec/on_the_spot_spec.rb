require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'on_the_spot/on_the_spot_helpers'

require 'action_controller'

RSpec.describe "OnTheSpot" do
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
        expect(@tester.lookup_display_value(@test_array_nr, 1)).to eq('abc')
      end

      it "should find value <value2> for key key2" do
        expect(@tester.lookup_display_value(@test_array_str, 'key2')).to eq('value2')
      end

      it "should return an empty string if key does not exist" do
        expect(@tester.lookup_display_value(@test_array_str, 'key1')).to eq('')
      end

      it "can handle single quotes normally" do
        expect(@tester.lookup_display_value(@test_array_nr, 4)).to eq("Freddy's Nightmare")
      end

    end

    context "convert array to json" do
      it "should convert correctly" do
        expect(@tester.convert_array_to_json(@test_array_nr, 1)).to eq("{\"1\":\"abc\",\"2\":\"def\",\"3\":\"ghi\",\"4\":\"Freddy's Nightmare\",\"selected\":1}")
      end

      it "convert an array containing an item with single quotes to valid JSON" do
        test_array_with_single_quote = [[1, "tree"], [2, "bike"], [3, "John's hat"]]
        json_str = @tester.convert_array_to_json(test_array_with_single_quote, 1)
        expect(json_str).to  eq("{\"1\":\"tree\",\"2\":\"bike\",\"3\":\"John's hat\",\"selected\":1}")
      end
    end

    context "the helpers" do
      before(:each) do
        @dummy = double()
        allow(@dummy).to receive(:content).and_return('test')
        allow(@dummy).to receive(:id).and_return('123')
        expect(@tester).to receive(:t).with('on_the_spot.ok').and_return("ok")
        expect(@tester).to receive(:t).with('on_the_spot.cancel').and_return("cancel")
        expect(@tester).to receive(:t).with('on_the_spot.tooltip').and_return("tooltip")
        expect(@tester).to receive(:t).with('on_the_spot.form_css').and_return(nil)
        expect(@tester).to receive(:t).with('on_the_spot.input_css').and_return(nil)
      end

      context "with standard route" do
        before(:each) do
          expect(@tester).to receive(:url_for).with({:action => 'update_attribute_on_the_spot'}).and_return('/bla')
        end

        it "makes the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">test</span>")
        end

        it "makes the correct html for an edit-field with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :selected => true
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-selected=\"true\">test</span>")
        end

        it "makes the correct html for an edit-field and overrule display-text" do
          @result = @tester.on_the_spot_edit @dummy, :content, :display_text => 'jediknight'
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">jediknight</span>")
        end

        it "makes the correct html for an edit-field and use the display-method as string" do
          expect(@dummy).to receive(:changed_content).and_return("test-changed")
          expect(@tester).to receive(:url_for).with({:action => 'get_attribute_on_the_spot'}).and_return('/bla-again')

          @result = @tester.on_the_spot_edit @dummy, :content, :display_method => 'changed_content'
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-display-method=\"changed_content\" data-loadurl=\"/bla-again\">test-changed</span>")
        end

        it "makes the correct html for an edit-field and use the display-method (as symbol)" do
          allow(@dummy).to receive(:changed_content).and_return("test-changed")
          allow(@tester).to receive(:url_for).with({:action => 'get_attribute_on_the_spot'}).and_return('/bla-again')

          @result = @tester.on_the_spot_edit @dummy, :content, :display_method => :changed_content
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-display-method=\"changed_content\" data-loadurl=\"/bla-again\">test-changed</span>")
        end


        it "makes the correct html for a text-area" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"textarea\" data-rows=\"5\" data-columns=\"40\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">test</span>")
        end

        it "makes the correct html for a text-area with text selected on click" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :textarea, :selected => true
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"textarea\" data-rows=\"5\" data-columns=\"40\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-selected=\"true\">test</span>")
        end

        it "makes the correct html for a select-box" do
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :data => [['test', 'This a test'], ['prod', 'Pure Production'], ['QA', 'Quality Assurance']]
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"select\" data-select=\"{&quot;test&quot;:&quot;This a test&quot;,&quot;prod&quot;:&quot;Pure Production&quot;,&quot;QA&quot;:&quot;Quality Assurance&quot;,&quot;selected&quot;:&quot;test&quot;}\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">This a test</span>")
        end

        it "makes the correct html for a checkbox" do
          expect(@dummy).to receive(:content).and_return(true)
          @result = @tester.on_the_spot_edit @dummy, :content, :type => :checkbox
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"checkbox\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">true</span>")
        end

        it "makes the correct html for an edit-field with a callback" do
          @result = @tester.on_the_spot_edit @dummy, :content, :callback => 'testCallback(value, settings);'
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-callback=\"testCallback(value, settings);\">test</span>")
        end

        it "makes the correct html for an edit-field with an onblur action" do
          @result = @tester.on_the_spot_edit @dummy, :content, :onblur => 'submit'
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-onblur=\"submit\">test</span>")
        end

        it "makes the correct html for an edit-field with a loadurl" do
          @result = @tester.on_the_spot_edit @dummy, :content, :loadurl => '/load/data'
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-loadurl=\"/load/data\">test</span>")
        end

        context "a select-box with a loadurl" do
          it "makea the correct html (and not look up the value)" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data'
            expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"select\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-loadurl=\"/load/data\">test</span>")
          end

          it "use the display-text preferrably" do
            @result = @tester.on_the_spot_edit @dummy, :content, :type => :select, :loadurl => '/load/data', :display_text => 'ninja'
            expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-edittype=\"select\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\" data-loadurl=\"/load/data\">ninja</span>")
          end
        end
      end

      context "with explicit route" do
        before(:each) do
          allow(@tester).to receive(:url_for).with({:action => 'update_it_otherwise'}).and_return('/bla')
        end

        it "make the correct html for an edit-field" do
          @result = @tester.on_the_spot_edit @dummy, :content, :url => {:action => 'update_it_otherwise' }
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\">test</span>")
        end
      end

      context "with raw parameter" do
        before(:each) do
          allow(@tester).to receive(:url_for).with({:action => 'update_attribute_on_the_spot', :raw => true}).and_return('/bla?raw=true')
        end

        it "supports raw html" do
          allow(@dummy).to receive(:content).and_return('<b>test</b>')
          @result = @tester.on_the_spot_edit @dummy, :content, :raw => true
          expect(@result).to eq("<span id=\"r_spec/mocks/double__content__123\" class=\"on_the_spot_editing\" data-url=\"/bla?raw=true\" data-ok=\"ok\" data-cancel=\"cancel\" data-tooltip=\"tooltip\"><b>test</b></span>")
        end
      end
    end
  end
end

