require 'spec_helper'

describe ActiveMetadata::NotesController do

  context "given 3 notes @document#name" do

    render_views

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      (1..3).each do |i|
        @document.create_note_for(:name, "note#{i}")
      end
    end

    describe "GET 'index'" do

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

  end


end
