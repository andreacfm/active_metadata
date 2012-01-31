ActiveMetadata::Engine.routes.draw do

    #stream
    get ":model_name/:model_id/:field_name/stream" => 'stream#index', :as => 'active_metadata_stream'

    #notes
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "active_metadata_notes"
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "active_metadata_create_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#destroy', :via => :delete, :as => "active_metadata_destroy_note"
    match ':model_name/:model_id/:field_name/notes/:id/edit' => 'notes#edit', :via => :get, :as => "active_metadata_edit_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#update', :via => :put, :as => "active_metadata_update_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#show', :via => :get, :as => "active_metadata_show_note"
    match ':model_name/:model_id/:field_name/notes/starred' => 'notes#starred', :via => :get, :as => "active_metadata_starred_notes"
    match ':model_name/:model_id/:field_name/notes/:id/star' => 'notes#star', :via => :put, :as => "active_metadata_star_note"
    match ':model_name/:model_id/:field_name/notes/:id/unstar' => 'notes#unstar', :via => :put, :as => "active_metadata_unstar_note"

    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "active_metadata_histories"

    #attachments
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :via => :get, :as => "active_metadata_attachments"
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :via => :post, :as => "active_metadata_create_attachment"
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :via => :delete, :as => "active_metadata_destroy_attachment"
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#update', :via => :put, :as => "active_metadata_update_attachment"
    match ':model_name/:model_id/:field_name/attachments/starred' => 'attachments#starred', :via => :get, :as => "active_metadata_starred_attachments"
    match ':model_name/:model_id/:field_name/attachments/:id/star' => 'attachments#star', :via => :put, :as => "active_metadata_star_attachments"
    match ':model_name/:model_id/:field_name/attachments/:id/unstar' => 'attachments#unstar', :via => :put, :as => "active_metadata_unstar_attachments"

    #alerts
    get ':model_name/:model_id/:field_name/watchers' => 'watchers#index', :as => "active_metadata_watchers"
    post ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#create', :as => "active_metadata_set_watcher"
    delete ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#destroy', :as => "active_metadata_unset_watcher"
    # TODO missing routes to notice of a read message

end
