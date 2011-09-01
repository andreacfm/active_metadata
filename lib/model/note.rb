class Note
  include Mongoid::Document

  belongs_to :label

  field :note, :type => String
  
end