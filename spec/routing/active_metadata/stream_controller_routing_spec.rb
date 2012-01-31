require "spec_helper"

describe ActiveMetadata::StreamController do

  describe "routing" do

    before(:each) { @routes = ActiveMetadata::Engine.routes }

    it "recognizes and generate :model_name/:model_id/:field_name/stream" do
      { :get => "/model/12/field/stream" }.should route_to(:controller => 'active_metadata/stream', :action => 'index', :model_name => 'model', :model_id => '12',
                                                           :field_name =>'field')
    end


  end

end