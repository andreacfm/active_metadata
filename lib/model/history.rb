class History
  include Mongoid::Document
  embedded_in :label

  field :value, :type => String
  field :created_by, :type => Integer

end