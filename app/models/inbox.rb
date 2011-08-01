class Inbox < ActiveRecord::Base
  set_table_name :inboxes
  
  belongs_to :user
end
  