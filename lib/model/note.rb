class Note
  include Mongoid::Document

  embedded_in :label

  field :note, :type => String
  field :created_by, :type => Integer
  field :updated_by, :type => Integer
end