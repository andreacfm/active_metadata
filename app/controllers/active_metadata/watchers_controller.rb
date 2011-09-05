module ActiveMetadata
  class WatchersController < ApplicationController
    unloadable

    def index
      @document = eval(params[:model_name]).find params[:model_id] 
      @watchers = @document.watchers_for params[:field_name]      
      respond_to do |format|
        format.html { render :layout => false}
        format.xml  { render :xml => @notes }
        format.xls { send_data @watchers.to_xls_data(:columns => [:user,:created_at], :headers => [:nota,'inserita']), :filename => 'watchers.xls' }
      end
    end  

    def edit
      @document = eval(params[:model_name]).find params[:model_id] 
      @note = @document.note_for params[:field_name],params[:id]     
    end  

    def show
      @document = eval(params[:model_name]).find params[:model_id] 
      @note = @document.note_for params[:field_name],params[:id]     
    end  

    def create
      @document = eval(params[:model_name]).find params[:model_id]
      @document.create_note_for(params[:field_name], params[:note])
      respond_to do |format|
        # TODO redirect to edit
        format.js       
      end
    end

    def update
      @document = eval(params[:model_name]).find params[:model_id]
      @note = @document.note_for params[:field_name],params[:id]     
            
      respond_to do |format|
        if @document.update_note(params[:id],params[:note][:note])
          format.html { redirect_to(active_metadata_show_note_path(@document.class,@document.id,@note.label.name,@note._id), :notice => 'Note was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
        end
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
