require 'spec_helper'

describe ActiveMetadata::StreamController do

  context "given 1 note and 1 attachment for @document#name" do

    render_views

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.save_attachment_for(:name,test_pdf("pdf_test"))
      @document.create_note_for(:name, "note")
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

    end

  end



end
