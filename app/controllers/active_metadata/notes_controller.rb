module ActiveMetadata
  class NotesController < ApplicationController
                             
    unloadable

    # AJAX Controller for inserting a note
    def create
      @document = eval(params[:model_name]).find params[:model_id]
      @document.create_note_for(params[:field_name], params[:note])
      respond_to do |format|
        format.js { render 'index' }
      end
    end

    def destroy
      @document = eval(params[:model_name]).find params[:model_id]
      @document.delete_note(params[:id])
      @document.reload
      respond_to do |format|
        format.js { render 'index' }
      end
    end

  end

end
