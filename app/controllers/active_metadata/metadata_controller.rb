module ActiveMetadata
  class MetadataController < ApplicationController
                             
    unloadable

    # AJAX Controller for inserting a note
    def create
      @document = eval(params[:model_name]).find params[:model_id]
      @document.create_note_for(params[:field_name], params[:note])
      respond_to do |format|
        format.js { render 'notes' }
      end
    end
  end
end
