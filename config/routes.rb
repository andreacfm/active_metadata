Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at
  
  namespace "active_metadata" do
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "notes", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "create_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id' => 'notes#destroy', :via => :delete, :as => "delete_note", :path_prefix => mount_at 
  end   
           
#  map.:metadata_notes, :only => [:create,:destroy],  :controller => "active_metadata/notes", :path_prefix => mount_at
#
#  map.resource :metadata_attachments, :only => :create,  :controller => "active_metadata/attachments", :path_prefix => mount_at
#
end
