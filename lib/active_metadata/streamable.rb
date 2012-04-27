module ActiveMetadata::Streamable

  # return the streamables items by field in an ordered array
  # ActiveMetadata::CONFIG['streamables'] defines what models will be retrieved
  def stream_for(field, order_by = :updated_at)
    sort_stream(collect_stream_data(field), order_by)
  end

  # same as #stream_for but not filtered by field
  def stream_all_starred order_by = :updated_at
    sort_stream(collect_starred_stream_data, order_by)
  end

  private
  def sort_stream stream, order_by
    stream.sort{ |a,b| b.send(order_by) <=> a.send(order_by) }
  end

  def collect_stream_data field
    res = []
    ActiveMetadata::CONFIG['streamables'].each do |model|
      res.concat self.send(stream_collect_method(model.to_s),field).collect { |el| el }
    end
    res
  end

  def collect_starred_stream_data
    res = []
    ActiveMetadata::CONFIG['streamables'].each do |model|
      res.concat self.send("starred_#{model.to_s.pluralize}".to_sym).collect { |el| el }
    end
    res
  end

  def stream_collect_method model
    model.to_s == 'note' ? 'notes_for' : 'attachments_for'
  end


end