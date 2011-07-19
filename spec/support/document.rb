# encoding: utf-8
class Document < ActiveRecord::Base  
  set_table_name :documents

  act_as_metadata

end