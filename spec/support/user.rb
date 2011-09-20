# encoding: utf-8
class User < ActiveRecord::Base  
  set_table_name :users 
   
  has_one :inbox
  
  @@current_user = User.create!
  
  def self.current
    @@current_user
  end
    
end