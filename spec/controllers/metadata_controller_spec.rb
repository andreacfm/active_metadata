require 'spec_helper'

describe MetadataController do
  context "create" do
    it "should create a new note" do
      post :create
      
      response.should be_success 
    end
  end
end