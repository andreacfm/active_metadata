class Note
  include Mongoid::Document

  belongs_to :label

  field :note, :type => String
  field :updated_by, :type => Integer
  field :updated_at, :type => Time 
  
  index :updated_at
  
end