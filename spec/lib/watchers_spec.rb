require "spec_helper"
require "time"

describe ActiveMetadata do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
  end

  describe "watchers" do

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