# encoding: utf-8
class Document < ActiveRecord::Base  
  include ActiveMetadata
  set_table_name :documents
end