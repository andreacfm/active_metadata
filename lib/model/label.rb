class Label
  include Mongoid::Document
  embedded_in :active_meta
  embeds_many :notes, :class_name => "Note"
  field :name
end