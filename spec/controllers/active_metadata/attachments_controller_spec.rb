require 'spec_helper'

describe ActiveMetadata::AttachmentsController do

  render_views

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
  end


  describe "GET 'index'" do

    before(:each) do
      (1..2).each do |i|
        @document.save_attachment_for(:name, test_pdf("pdf_test_#{i}"))
      end
    end

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

  describe "#create" do

    it "should create an attachment for a passed group" do
      post :create, :model_name => 'document', :model_id => @document.id, :field_name => 'name', :group => "my_group", :format => :js,
           :file => test_pdf
      response.should be_success
      ActiveMetadata::Stream.by_group("my_group").count.should eq 1
    end

    it "should create a starred attachment" do
      post :create, :model_name => 'document', :model_id => @document.id, :field_name => 'name', :starred => true, :format => :js,
      :file => test_pdf
      response.should be_success
      @document.attachments_for(:name).last.should be_starred
    end

  end


end
