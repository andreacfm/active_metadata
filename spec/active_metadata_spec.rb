require "spec_helper"
require "rack/test/uploaded_file"
require "time"

describe ActiveMetadata do

  context "model methods" do

    it "should exist a method acts_as_metadata in the model" do
      Document.respond_to?(:acts_as_metadata).should be_true
    end

    it "should find the active_metadata_ancestors if no active_metadata_ancestors params has been provided" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @document.metadata_id.should eq @document.id
      @document.metadata_class.should eq @document.class.to_s
    end

    it "should find the metadata_root.id if an active_metadata_ancestors params has been specified" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @section = @document.create_section :title => "new section"
      @section.reload
      @section.metadata_id.should eq @document.id
      @section.metadata_class.should eq @document.class.to_s
    end

  end

  context "history" do

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
    end

    it "should create history when a document is created" do
      @document.history_for(:name).should have(1).record
    end

    it "should create history for a defined field when a document is created" do
      @document.history_for(:name)[0].value.should eq(@document.name)
    end

    it "should verify that histories are created for the correct model" do
      @document.history_for(:name)[0].document_class.should eq(@document.class.to_s)
    end

    it "should save the craeted_at datetime anytime an history entry is created" do
      @document.history_for(:name)[0].created_at.should be_a_kind_of Time
    end

    it "should verify that history return records only for the self document" do
      # fixtures
      @another_doc = Document.create :name => "Andrea"
      @another_doc.reload

        # expectations
      @document.history_for(:name).count.should eq(1)
      @another_doc.history_for(:name).count.should eq(1)

      @document.history_for(:name).last.value.should eq @document.name
      @another_doc.history_for(:name).last.value.should eq @another_doc.name
    end

    it "should verify that history is saved with the correct model id if metadata_id_from is defined" do
      # fixtures
      @section = @document.create_section :title => "new section"
      @section.reload

        # expectations
      @document.history_for(:name).count.should eq(1)
      @document.history_for(:name).last.document_id.should eq @document.id

      @section.history_for(:title).count.should eq(1)
      @section.history_for(:title).last.document_id.should eq @document.id
    end

    it "should verify that history_for sort by created_at descending" do
      #fixtures
      3.times do |i|
        sleep 0.1.seconds
        @document.name = "name #{i}"
        @document.save
      end

      #expectations
      @document.history_for(:name).first.value.should eq "name 2"
      @document.history_for(:name).last.value.should eq "John"
    end
    
    it "should verify that no history is craeted for the skipped field defined in the config file" do
      @document.history_for(:name).should have(1).record
      @document.history_for(:id).should have(0).record      
    end

    it "should save the correct creator when a history is created" do
      current_user = User.current
      history = @document.history_for(:name).first
      history.created_by.should eq current_user.id  
    end

  end

  context "watchers" do
    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
    end
    
    it "should create a watcher for a given field" do      
        user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
        @document.create_watcher_for(:name, user)
        @document.watchers_for(:name).should have(1).record
    end   
    
    it "should delete a watcher for a given field" do
      user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
      @document.create_watcher_for(:name, user)
      @document.watchers_for(:name).should have(1).record
      
      @document.delete_watcher_for :name, user
      @document.watchers_for(:name).should have(0).record      
    end

    it "should return false if field is not watched by the passed user" do
      user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
      another_user = User.create!(:email => "email2@email.it", :firstname => 'George', :lastname => 'Washington' )

      @document.create_watcher_for(:name, user)
      @document.is_watched_by(:name,user).should be_true
      @document.is_watched_by(:name,another_user).should be_false
    end           
    

    it "should create an unread message by default" do      
          pending "to be moved in virgilio project"
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          @document.update_attribute(:name, 'new_value')          
          

          user.inbox.messages.should have(1).record
          user.inbox.messages.first.read.should be_false
    end

    it "should read an unread message" do      
          pending "to be moved in virgilio project"
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          @document.update_attribute(:name, 'new_value')          
          alert_message = user.inbox.messages.first
          alert_message.mark_as_read
          user.inbox.messages.first.read.should be_true
    end

  end

end
