module ActiveMetadata
  class HistoriesController < ApplicationController

     unloadable

      def index
         @document = eval(params[:model_name]).find params[:model_id] 
         @histories = @document.history_for params[:field_name]      
         respond_to do |format|
           format.html { render :layout => false}
           format.xml  { render :xml => @histories }
         end
      end  

  end
end
