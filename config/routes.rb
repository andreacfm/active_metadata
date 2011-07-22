Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at

  match mount_at => 'cheese/widgets#index'
           
  map.resource :metadata, :only => :create, :path_prefix => mount_at
    
  # 
  # map.resources :widgets, :only => [ :index, :show ],
  #                         :controller => "cheese/widgets",
  #                         
  #                         :name_prefix => "cheese_"

end
