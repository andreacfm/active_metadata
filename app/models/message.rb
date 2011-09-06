class Message < ActiveRecord::Base
  set_table_name :alert_messages
  
  belongs_to :inbox     
  
  def mark_as_read
    update_attribute(:read, true)
  end
end