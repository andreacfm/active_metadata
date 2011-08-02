class Message < ActiveRecord::Base
  set_table_name :alert_messages
  
  belongs_to :inbox  
end