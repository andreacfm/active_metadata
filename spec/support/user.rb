# encoding: utf-8
class User < ActiveRecord::Base  
  set_table_name :users  

  has_one :inbox
end