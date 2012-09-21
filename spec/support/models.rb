# encoding: utf-8
class Document < ActiveRecord::Base
  has_one :section
  has_one :author
  acts_as_metadata
end

# Persist ancestor
class Section < ActiveRecord::Base
  belongs_to :document
  acts_as_metadata :ancestors => [:document], :persists_ancestor => true
end

# Does not persist ancestor
class Author < ActiveRecord::Base
  belongs_to :document
  acts_as_metadata :ancestors => [:document]
end

class Chapter < ActiveRecord::Base
  acts_as_metadata ancestors: [:sections, :document]
  has_many :sections
end

class User < ActiveRecord::Base
  has_one :inbox

  @@current_user = User.create!

  def self.current
    @@current_user
  end

end