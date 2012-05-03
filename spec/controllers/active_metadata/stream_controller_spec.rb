require 'spec_helper'

describe ActiveMetadata::StreamController do

  context "given 1 note and 1 attachment for @document#name" do

    render_views

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.save_attachment_for(:name,test_pdf("pdf_test"))
      @document.create_note_for(:name, "nota per name john")
    end

    describe "GET 'index'" do

      it "should success" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.should be_success
      end

      it "should assign document" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        assigns(:document).should_not be_nil
        assigns(:document).id.should eq @document.id
      end

      it "should assign stream" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        assigns(:stream).should_not be_nil
        assigns(:stream).size.should eq 2
      end

      it "should render both note and the attachment" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.body.should match(/pdf_test.pdf/)
        response.body.should match(/nota per name john/)
      end

      describe "GET 'index by group'" do
        before(:each) do
          @chapter = Chapter.create! { |d| d.title = "Cool!" }
          @document.save_attachment_for(:name, test_pdf("pdf_test_1"), false, 'my_group')
          @chapter.save_attachment_for(:title, test_pdf("pdf_test_2"), true, 'my_group')
          @document.create_note_for(:name, "grouped nota per name john", true, 'your_group')
        end

        it "should return the stream of a particular group" do
          get 'index', :group => 'my_group'
          response.body.should match(/pdf_test_1.pdf/)
          response.body.should match(/pdf_test_2.pdf/)
          response.body.should_not match(/grouped nota/)
        end

      end
    end

  end



end
