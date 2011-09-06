module ActiveMetadata
  class MessagesController < ApplicationController
    unloadable

    def index
      @document = eval(params[:model_name]).find params[:model_id]          
      user = User.find(params[:user_id]) 
      @messages = user.inbox.nil? ? [] : user.inbox.messages.where(:read => false) 
      respond_to do |format|
        format.html { render :layout => false}
        format.xml  { render :xml => @messages }
      end
    end
    
    def mark_as_read
      @message = Message.find params[:message_id]
      @message.mark_as_read
      respond_to do |format|
        format.js 
      end            
    end    
  end
end                