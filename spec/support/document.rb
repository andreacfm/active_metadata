# encoding: utf-8
class Document < ActiveRecord::Base  
  has_one :section
  acts_as_metadata

end