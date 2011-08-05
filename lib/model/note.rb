class Note
  include Mongoid::Document

  embedded_in :label

  field :note, :type => String
  
end