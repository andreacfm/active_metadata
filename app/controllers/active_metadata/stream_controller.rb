module ActiveMetadata
  class StreamController < ApplicationController

    def index
      @document = params[:model_name].to_class.find(params[:model_id])
      @stream = @document.stream_for params[:field_name]
    end

  end
end
