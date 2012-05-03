module ActiveMetadata
  class StreamController < ApplicationController

    layout false

    def index
      if params[:group]
        @stream = ActiveMetadata::Stream.by_group params[:group]
      else
        @document = params[:model_name].to_class.find(params[:model_id])
        @stream = @document.stream_for params[:field_name]
      end
    end

  end
end
