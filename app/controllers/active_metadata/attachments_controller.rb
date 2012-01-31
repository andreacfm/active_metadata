module ActiveMetadata
  class AttachmentsController < ApplicationController

    def index
      @document = params[:model_name].to_class.find(params[:model_id])
       @attachments = @document.attachments_for params[:field_name]      
       respond_to do |format|
         format.html { render :layout => false}
         format.xml  { render :xml => @histories }
       end
    end  

    def create
      @document = params[:model_name].to_class.find(params[:model_id])
      @document.save_attachment_for(params[:field_name], params[:file])
      
      #todo: if errors send back the correct answer
      respond_to do |format|
        format.js {render :json => {'success' => true}}
      end
    end

    def update
      @document = params[:model_name].to_class.find(params[:model_id])
      @document.update_attachment(params[:id],params[:file])
      
      #todo: if errors send back the correct answer
      respond_to do |format|
        format.js {render :json => {'success' => true}}
      end
    end

    def destroy
      @document = params[:model_name].to_class.find(params[:model_id])
      @document.delete_attachment(params[:id])
      
      #todo: if errors send back the correct answer
      respond_to do |format|
        # TODO redirect to index
        format.js
      end
    end

  end
end
