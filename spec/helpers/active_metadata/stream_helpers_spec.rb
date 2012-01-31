require "spec_helper"

describe ActiveMetadata::StreamHelper do

  include ActiveMetadata::StreamHelper

  describe "stream_partial_name" do

    it "should return the partial name to render notes" do
      stream_partial_path(Note.new).should eq 'active_metadata/notes/note'
    end

  end

end