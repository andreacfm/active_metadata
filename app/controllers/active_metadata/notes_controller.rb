module ActiveMetadata
  class NotesController < ApplicationController

    unloadable

    def index
      @document = eval(params[:model_name]).find params[:model_id] 
      @notes = @document.notes_for params[:field_name]      
      respond_to do |format|
        format.html { render :layout => false}
        format.xml  { render :xml => @notes }
        format.xls { send_data @notes.to_xls_data(:columns => [:note,:created_at], :headers => [:nota,'inserita']), :filename => 'notes.xls' }        
      end
    end  

    def create
      @document = eval(params[:model_name]).find params[:model_id]
      @document.create_note_for(params[:field_name], params[:note])
      respond_to do |format|
        # TODO redirect to edit
        format.js       
      end
    end

    def destroy
      @document = eval(params[:model_name]).find params[:model_id]
      @document.delete_note_for(params[:field_name],params[:id])
      respond_to do |format|
        # TODO redirect to index
        format.js
      end
    end

  end

end
