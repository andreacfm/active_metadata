# encoding: utf-8
class Section < ActiveRecord::Base
  belongs_to :document

  acts_as_metadata :active_metadata_ancestors => [:document]

end