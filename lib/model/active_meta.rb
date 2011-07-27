class ActiveMeta
  include Mongoid::Document

  embeds_many :labels, :class_name => "Label"

  field :document_id, type: Integer

end