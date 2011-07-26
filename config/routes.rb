Rails.application.routes.draw do |map|

  mount_at = ActiveMetadata::Engine.config.mount_at
           
  map.resource :metadata_notes, :only => [:create,:destroy],  :controller => "active_metadata/notes", :path_prefix => mount_at

  map.resource :metadata_attachments, :only => :create,  :controller => "active_metadata/attachments", :path_prefix => mount_at

end
