class Label
  include Mongoid::Document  
  field :name
  
  embedded_in :active_meta
  has_many :notes, :class_name => "Note"
  has_many :histories, :class_name => "History"
  has_many :attachments, :class_name => "Attachment"
  has_many :watchers, :class_name => "Watcher"
  
  index :name
  
end
