require 'spec_helper'

describe ActiveMetadata::NotesController do


    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
    end

    describe "GET 'index'" do

      render_views

      before(:each) do
        (1..3).each do |i|
          @document.create_note_for(:name, "note#{i}")
        end
      end

      it "should success" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.should be_success
      end

      it "should assign notes" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        assigns(:notes).should_not be_nil
        assigns(:notes).size.should eq 3
      end

      it "should display 3 notes" do
        get 'index', :model_name => 'document', :model_id => @document.id, :field_name => 'name'
        response.body.should match(/note1/)
        response.body.should match(/note2/)
        response.body.should match(/note3/)
      end

    end

    describe "#create" do

      it "should create a note for a passed group" do
        post :create, :model_name => 'document', :model_id => @document.id, :field_name => 'name', :group => "my_group", :format => :js
        response.should be_success
        ActiveMetadata::Stream.by_group("my_group").count.should eq 1
      end

      it "should create a starred note" do
        post :create, :model_name => 'document', :model_id => @document.id, :field_name => 'name', :starred => true, :format => :js
        response.should be_success
        @document.notes_for(:name).last.should be_starred
      end

    end


end
