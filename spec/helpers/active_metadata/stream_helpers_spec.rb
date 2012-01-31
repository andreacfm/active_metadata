require "spec_helper"

describe ActiveMetadata::StreamHelper do

  include ActiveMetadata::StreamHelper

  describe "stream_partial_name" do

    it "should return the partial name to render notes" do
      stream_partial_path(ActiveMetadata::Note.new).should eq 'active_metadata/notes/note'
    end

  end

  describe "clean_class_name" do

    it "should remove the module from a class name" do
      clean_class_name('ActiveMetadata::Note').should eq 'Note'
    end

  end

end