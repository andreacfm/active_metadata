module ActiveMetadata::Streamable

  def stream_for field
    sort_stream(collect_stream_data(field))
  end

  private
  def sort_stream stream
    stream.sort{|a,b| b.updated_at <=> a.updated_at}
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