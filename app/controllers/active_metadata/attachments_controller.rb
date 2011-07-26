module ActiveMetadata
  class AttachmentsController < ApplicationController

    unloadable

    # AJAX Controller for inserting a note
    def create
      @document = eval(params[:model_name]).find params[:model_id]
      @document.save_attachment_for(params[:field_name], params[:file])
      respond_to do |format|
        format.js {render :json => {'success' => true}}
      end
    end
  end

end
