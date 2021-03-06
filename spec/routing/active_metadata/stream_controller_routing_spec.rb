require "spec_helper"

describe ActiveMetadata::StreamController do

  describe "routing" do

    before(:each) { @routes = Rails.application.routes }

    it "recognizes and generate :model_name/:model_id/:field_name/stream" do
      { :get => "/active_metadata/model/12/field/stream" }.should route_to(
        :controller => 'active_metadata/stream', :action => 'index', :model_name => 'model', :model_id => '12', :field_name =>'field')
    end

    it "recognizes and generate group/:group/stream" do
      { :get => "/active_metadata/groups/my_group/stream" }.should route_to(
        :controller => 'active_metadata/stream', :action => 'index_by_group', :group =>'my_group')
    end


  end

end