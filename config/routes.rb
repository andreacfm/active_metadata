Rails.application.routes.draw do

  namespace :active_metadata do
    #stream
    get ":model_name/:model_id/:field_name/stream" => 'stream#index', :as => 'stream'
    #get "group/:group_name/stream" => 'stream#index', :as => 'group_stream'
    #get "group/:group_name/stream/starred" => 'stream#index', :as => 'group_stream_starred'

    #notes
    get ':model_name/:model_id/:field_name/notes' => 'notes#index', :as => "notes"
    post ':model_name/:model_id/:field_name/notes' => 'notes#create', :as => "create_note"
    delete ':model_name/:model_id/:field_name/notes/:id' => 'notes#destroy', :as => "destroy_note"
    get ':model_name/:model_id/:field_name/notes/:id/edit' => 'notes#edit', :as => "edit_note"
    put ':model_name/:model_id/:field_name/notes/:id' => 'notes#update', :as => "update_note"
    get ':model_name/:model_id/:field_name/notes/:id' => 'notes#show', :as => "show_note"
    get ':model_name/:model_id/:field_name/notes/starred' => 'notes#starred', :as => "starred_notes"
    put ':model_name/:model_id/:field_name/notes/:id/star' => 'notes#star', :as => "star_note"
    put ':model_name/:model_id/:field_name/notes/:id/unstar' => 'notes#unstar', :as => "unstar_note"

    #history
    match ':model_name/:model_id/:field_name/histories' => 'histories#index', :via => :get, :as => "histories"

    #attachments
    get ':model_name/:model_id/:field_name/attachments' => 'attachments#index', :as => "attachments"
    post ':model_name/:model_id/:field_name/attachments' => 'attachments#create', :as => "create_attachment"
    delete ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#destroy', :as => "destroy_attachment"
    put ':model_name/:model_id/:field_name/attachments/:id' => 'attachments#update', :as => "update_attachment"
    get ':model_name/:model_id/:field_name/attachments/starred' => 'attachments#starred', :as => "starred_attachments"
    put ':model_name/:model_id/:field_name/attachments/:id/star' => 'attachments#star', :as => "star_attachments"
    put ':model_name/:model_id/:field_name/attachments/:id/unstar' => 'attachments#unstar', :as => "unstar_attachments"

    #alerts
    get ':model_name/:model_id/:field_name/watchers' => 'watchers#index', :as => "watchers"
    post ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#create', :as => "set_watcher"
    delete ':model_name/:model_id/:field_name/watchers/:user_id' => 'watchers#destroy', :as => "unset_watcher"
    # TODO missing routes to notice of a read message
  end

end
