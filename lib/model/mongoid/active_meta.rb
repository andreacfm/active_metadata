class ActiveMeta
  include Mongoid::Document
  field :document_id, type: Integer
  has_many :labels, :class_name => "Label"
  index :document_id
end