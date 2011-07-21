# encoding: utf-8
class Document < ActiveRecord::Base  
  set_table_name :documents
  has_one :section

  acts_as_metadata

end