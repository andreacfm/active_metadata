Rails.application.routes.draw do

  namespace :active_metadata do
    #stream
    get ":model_name/:model_id/:field_name/stream" => 'stream#index', :as => 'stream'

    #notes
    match ':model_name/:model_id/:field_name/notes' => 'notes#index', :via => :get, :as => "notes"
    match ':model_name/:model_id/:field_name/notes' => 'notes#create', :via => :post, :as => "create_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#destroy', :via => :delete, :as => "destroy_note"
    match ':model_name/:model_id/:field_name/notes/:id/edit' => 'notes#edit', :via => :get, :as => "edit_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#update', :via => :put, :as => "update_note"
    match ':model_name/:model_id/:field_name/notes/:id' => 'notes#show', :via => :get, :as => "show_note"
    match ':model_name/:model_id/:field_name/notes/starred' => 'notes#starred', :via => :get, :as => "starred_notes"
    match ':model_name/:model_id/:field_name/notes/:id/star' => 'notes#star', :via => :put, :as => "star_note"
    match ':model_name/:model_id/:field_name/notes/:id/unstar' => 'notes#unstar', :via => :put, :as => "unstar_note"

    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "histories"

    #attachments
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :via => :get, :as => "attachments"
    match ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :via => :post, :as => "create_attachment"
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :via => :delete, :as => "destroy_attachment"
    match ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#update', :via => :put, :as => "update_attachment"
    match ':model_name/:model_id/:field_name/attachments/starred' => 'attachments#starred', :via => :get, :as => "starred_attachments"
    match ':model_name/:model_id/:field_name/attachments/:id/star' => 'attachments#star', :via => :put, :as => "star_attachments"
    match ':model_name/:model_id/:field_name/attachments/:id/unstar' => 'attachments#unstar', :via => :put, :as => "unstar_attachments"

    #alerts
    get ':model_name/:model_id/:field_name/watchers' => 'watchers#index', :as => "watchers"
    post ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#create', :as => "set_watcher"
    delete ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#destroy', :as => "unset_watcher"
    # TODO missing routes to notice of a read message
  end

end
