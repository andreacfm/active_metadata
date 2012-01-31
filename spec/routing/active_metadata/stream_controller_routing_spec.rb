require "spec_helper"

describe ActiveMetadata::StreamController do

  describe "routing" do

    it "recognizes and generate index" do
      { :get => "/stream/index" }.should be_routable
    end


  end

end