require 'spec_helper'

describe ActiveMetadata::AttachmentsController do

  context "given 2 attachments for @document#name" do

    render_views

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      (1..2).each do |i|
        @document.save_attachment_for(:name,test_pdf("pdf_test_#{i}"))
     end
    end

    describe "GET 'index'" do

      it "should success" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.should be_success
      end

      it "should assign attachments" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        assigns(:attachments).should_not be_nil
        assigns(:attachments).size.should eq 2
      end

      it "should display 3 notes" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.body.should match(/pdf_test_1.pdf/)
        response.body.should match(/pdf_test_2.pdf/)
      end

    end

  end


end
