class Watcher
  include Mongoid::Document

  embedded_in :label

  field :owner, :type => String
end
