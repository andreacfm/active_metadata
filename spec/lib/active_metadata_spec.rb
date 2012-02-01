require "spec_helper"
require "rack/test/uploaded_file"
require "time"

describe ActiveMetadata do

  context "model methods" do

    it "should exist a method acts_as_metadata in the model" do
      Document.respond_to?(:acts_as_metadata).should be_true
    end

    it "should find the active_metadata_ancestors if no active_metadata_ancestors params has been provided" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @document.metadata_id.should eq @document.id
      @document.metadata_class.should eq @document.class.to_s
    end

    it "should find the metadata_root.id if an active_metadata_ancestors params has been specified" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @section = @document.create_section :title => "new section"
      @section.reload
      @section.metadata_id.should eq @document.id
      @section.metadata_class.should eq @document.class.to_s
    end

  end

  context "saving a child object before active_metadata_ancestors" do

    it "should save the history when the ancestor saves" do
      section = Section.create! :title => 'section title'
      doc = Document.create! :name => 'doc_name', :section => section

      Section.find(section.id).history_for(:title).first.value.should eq 'section title'
    end

  end

end
