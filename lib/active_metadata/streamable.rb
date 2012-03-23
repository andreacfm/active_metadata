module ActiveMetadata::Streamable

  def stream_for(field, order_by = :created_at)
    sort_stream(collect_stream_data(field), order_by)
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

  def stream_collect_method model
    model.to_s == 'note' ? 'notes_for' : 'attachments_for'
  end


end