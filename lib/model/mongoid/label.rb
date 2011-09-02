class Label
  include Mongoid::Document  
  field :name
  
  belongs_to :active_meta, :class_name => "ActiveMeta"
  
  has_many :notes, :class_name => "Note"
  has_many :histories, :class_name => "History"
  has_many :attachments, :class_name => "Attachment"
  has_many :watchers, :class_name => "Watcher"
  
  index :name
  
end
