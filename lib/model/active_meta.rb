class ActiveMeta
  include Mongoid::Document
  embeds_many :labels
  field :document_id, type: Integer
end