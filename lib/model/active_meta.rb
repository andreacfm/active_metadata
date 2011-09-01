class ActiveMeta
  include Mongoid::Document
  field :document_id, type: Integer

  index :document_id
  index "labels.name"

  embeds_many :labels, :class_name => "Label"
end