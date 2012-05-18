# encoding: utf-8
class Section < ActiveRecord::Base
  belongs_to :document

  acts_as_metadata :ancestors => [:document], :persists_ancestor => true

end