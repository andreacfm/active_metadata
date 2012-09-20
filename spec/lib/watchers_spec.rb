require "spec_helper"
require "time"

describe ActiveMetadata do


  describe "watchers" do

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

  end

  describe "#watchers_for" do

    context "when some record does not relate to a specific model instance" do

      before do
        @user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
        @another_user = User.create!(:email => "email2@email.it", :firstname => 'George', :lastname => 'Washington' )
        @document = Document.create! { |d| d.name = "John" }
        @document.create_watcher_for(:name, @user)
        ActiveMetadata::Watcher.create! :model_class => "Document", :label => :name, :owner_id => @another_user.id
      end

      it "should return all the records that match model/field" do
        docs = @document.watchers_for(:name)
        docs.count.should eq 2
      end

      it "should group result by owner" do
        @document.create_watcher_for(:name, @another_user)
        ActiveMetadata::Watcher.create! :model_class => "Document", :label => :name, :owner_id => @user.id
        docs = @document.watchers_for(:name)
        docs.count.should eq 2
      end

    end


  end

end