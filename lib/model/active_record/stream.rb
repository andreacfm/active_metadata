class Stream

  @streamables =  ActiveMetadata::CONFIG['streamables']

  class << self

    # perform the stream using the streamables models
    def stream_for

    end

    private

    def collect_data
      res = []
      @streamables.each do |model|
        model.to_class.all.each do |el|
          res << el
        end
      end
    end

  end


end