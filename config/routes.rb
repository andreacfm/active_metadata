Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at
           
  map.resource :notes, :only => :create,  :controller => "active_metadata/notes", :path_prefix => mount_at
    
  # 
  # map.resources :widgets, :only => [ :index, :show ],
  #                         :controller => "cheese/widgets",
  #                         
  #                         :name_prefix => "cheese_"

end
