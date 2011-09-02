class Label
  include Mongoid::Document  
  field :name
  
  embedded_in :active_meta
  embeds_many :notes, :class_name => "Note"
  embeds_many :histories, :class_name => "History"
  embeds_many :attachments, :class_name => "Attachment"
  embeds_many :watchers, :class_name => "Watcher"
  
end
