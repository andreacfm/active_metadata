Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at
  
  namespace "active_metadata" do
    #note
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "notes", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "create_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id' => 'notes#destroy', :via => :delete, :as => "destroy_note", :path_prefix => mount_at 
    
    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "histories", :path_prefix => mount_at 

    #attachments
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :via => :get, :as => "attachments", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :via => :post, :as => "create_attachment", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :via => :delete, :as => "destroy_attachment", :path_prefix => mount_at   
    
  end   

end
