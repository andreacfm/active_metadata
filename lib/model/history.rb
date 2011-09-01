class History
  include Mongoid::Document
  store_in :history
  belongs_to :label

  field :value, :type => String

end