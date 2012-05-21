require "spec_helper"
require "rack/test/uploaded_file"
require "time"

describe ActiveMetadata do

  context "class methods" do

    it "should exist a method acts_as_metadata in the model" do
      Document.respond_to?(:acts_as_metadata).should be_true
    end

    it "should find the ancestors if no ancestors params has been provided" do
      @document = Document.create! { |d| d.name = "John" }
      @document.metadata_id.should eq @document.id
      @document.metadata_class.should eq @document.class.to_s
    end

    it "should find the metadata_root.id if an ancestors params has been specified and persists_ancestor is true" do
      @document = Document.create! { |d| d.name = "John" }
      @section = @document.create_section :title => "new section"
      @section.metadata_id.should eq @document.id
      @section.metadata_class.should eq @document.class.to_s
    end

  end

  context "saving a child object before active_metadata_ancestors" do

    it "should raise an exception cause ancestor id is not defined" do
      lambda{Section.create! :title => 'section title'}.should raise_error(RuntimeError,"[active_metdata] - Ancestor model is not yet persisted")
    end

  end

  context "ancestors" do

    it "should return the base instance class following the ancestor chain" do
      @document = Document.create! { |d| d.name = "John" }
      @chapter = Chapter.create(title: "title")
      @section = @document.create_section
      @section.metadata_id(true).should eq @document.id
      @section.metadata_class(true).should eq "Document"
    end

    it "should return the base instance class following the ancestor chain passing has_many associations" do
      @document = Document.create! { |d| d.name = "John" }
      @chapter = Chapter.create(title: "title")
      @section = @document.create_section chapter_id: @chapter.id

      @chapter.metadata_id(true).should eq @document.id
      @chapter.metadata_class(true).should eq "Document"
    end

  end


end
