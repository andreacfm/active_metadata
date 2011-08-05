class ActiveMeta
  include Mongoid::Document

  embeds_many :labels, :class_name => "Label"

  field :document_id, type: Integer
  
  index :document_id
  index "labels.name"

end