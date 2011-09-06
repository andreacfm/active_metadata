Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at
  
  namespace "active_metadata" do
    #note
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "notes", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "create_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id' => 'notes#destroy', :via => :delete, :as => "destroy_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id/edit' => 'notes#edit', :via => :get, :as => "edit_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id' => 'notes#update', :via => :put, :as => "update_note", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/note/:id' => 'notes#show', :via => :get, :as => "show_note", :path_prefix => mount_at 
    
    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "histories", :path_prefix => mount_at 

    #attachments
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :via => :get, :as => "attachments", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :via => :post, :as => "create_attachment", :path_prefix => mount_at 
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :via => :delete, :as => "destroy_attachment", :path_prefix => mount_at   
                                                                                              
    #alerts
    get ':model_name/:model_id/:field_name/:user_id/messages' => 'messages#index', :as => "messages", :path_prefix => mount_at 
    put 'messages/:message_id/read' => 'messages#mark_as_read', :as => "read_message", :path_prefix => mount_at 
    get ':model_name/:model_id/:field_name/watchers' => 'watchers#index', :as => "watchers", :path_prefix => mount_at 
    post ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#create',:as => "set_watcher", :path_prefix => mount_at 
    delete ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#destroy',:as => "unset_watcher", :path_prefix => mount_at 
    # TODO missing routes to notice of a read message
  end   

end
