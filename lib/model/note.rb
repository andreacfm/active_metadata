class Note
  include Mongoid::Document
  
  after_create :watcher_callback
  
  embedded_in :label

  field :note, :type => String  
  
  private 
  
  def watcher_callback
    watchers_for(label).each { |watch| watch.notify_changes(label.name, note) }
  end

end