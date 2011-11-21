Rails.application.routes.draw do

  mount_at = ActiveMetadata::Engine.config.mount_at
  
  namespace "active_metadata" do
    #note
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "notes", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "create_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#destroy', :via => :delete, :as => "destroy_note", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/:id/edit' => 'notes#edit', :via => :get, :as => "edit_note", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#update', :via => :put, :as => "update_note", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#show', :via => :get, :as => "show_note", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/starred' => 'notes#starred', :via => :get, :as => "starred_notes", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/:id/star' => 'notes#star', :via => :put, :as => "star_note", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/notes/:id/unstar' => 'notes#unstar', :via => :put, :as => "unstar_note", :path_prefix => mount_at

    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "histories", :path_prefix => mount_at 

    #attachments
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :via => :get, :as => "attachments", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :via => :post, :as => "create_attachment", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :via => :delete, :as => "destroy_attachment", :path_prefix => mount_at   
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#update', :via => :put, :as => "update_attachment", :path_prefix => mount_at   
    match ':model_name/:model_id/:field_name/attachments/starred' => 'attachments#starred', :via => :get, :as => "starred_attachments", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/attachments/:id/star' => 'attachments#star', :via => :put, :as => "star_attachments", :path_prefix => mount_at
    match ':model_name/:model_id/:field_name/attachments/:id/unstar' => 'attachments#unstar', :via => :put, :as => "unstar_attachments", :path_prefix => mount_at

    #alerts
    get ':model_name/:model_id/:field_name/watchers' => 'watchers#index', :as => "watchers", :path_prefix => mount_at 
    post ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#create',:as => "set_watcher", :path_prefix => mount_at 
    delete ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#destroy',:as => "unset_watcher", :path_prefix => mount_at 
    # TODO missing routes to notice of a read message
  end   

end
