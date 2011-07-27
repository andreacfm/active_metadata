class History
  include Mongoid::Document
  store_in :history
  embedded_in :label

  field :value, :type => String

end