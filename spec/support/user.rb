# encoding: utf-8
class User < ActiveRecord::Base  
  has_one :inbox
  
  @@current_user = User.create!
  
  def self.current
    @@current_user
  end
    
end