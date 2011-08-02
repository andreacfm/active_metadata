class Inbox < ActiveRecord::Base
  set_table_name :inboxes
  
  belongs_to :user 
  has_many :messages
end
  