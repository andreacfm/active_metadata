class Label
  include Mongoid::Document
  embedded_in :metadata

#  embeds_many :notes

  field :name, type: String

end