module ActiveMetadata
  class WatchersController < ApplicationController
    unloadable

    def index
      @document = eval(params[:model_name]).find params[:model_id]

      @watchers = @document.watchers_for params[:field_name]

      respond_to do |format|
        format.html { render :layout => false}
        format.xml  { render :xml => @watchers }
      end
    end

    def create
      @document = eval(params[:model_name]).find params[:model_id]     
      @document.create_watcher_for params[:field_name], User.find(params[:user_id])

      respond_to do |format|
        format.js       
      end
    end       
    
    def destroy
      @document = eval(params[:model_name]).find params[:model_id]     
      @document.delete_watcher_for params[:field_name], User.find(params[:user_id])
      respond_to do |format|
        format.js       
      end
    end
    
  end
end