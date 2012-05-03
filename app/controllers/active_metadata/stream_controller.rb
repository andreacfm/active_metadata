module ActiveMetadata
  class StreamController < ApplicationController

    layout false

    def index
      @document = params[:model_name].to_class.find(params[:model_id])
      @stream = @document.stream_for params[:field_name]
    end

    def index_by_group
      @stream = ActiveMetadata::Stream.by_group params[:group], starred_condition
      render :index
    end

    private
    def starred_condition
      params[:starred].nil? ? nil : {:starred => true}
    end
  end
end
