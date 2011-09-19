class WatcherNotifier
  attr_accessor :matched_label, :old_value, :new_value, :model_class, :model_id, :type

  def initialze
    puts "---------------------------------------->"
  end

  def notify(matched_label, old_value, new_value, model_class, model_id,owner_id,type)          
     @matched_label= matched_label
     @old_value = old_value
     @new_value = new_value
     @model_class = model_class
     @model_id = model_id 
     @type = type

     puts "fake notification sent for label #{@matched_label} with value #{@new_value}"

  end

end