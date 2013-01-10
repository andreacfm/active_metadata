require "spec_helper"
require "time"

describe ActiveMetadata do


  describe "history" do

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
      @document.history_for(:name)[0].model_class.should eq(@document.class.to_s)
    end

    it "should save the craeted_at datetime anytime an history entry is created" do
      @document.history_for(:name)[0].created_at.should be_a_kind_of Time
    end

    it "should not save the history and send any notification if new value and old are both nil" do
      # see
      # https://github.com/rails/rails/issues/8874
      @user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith')
      ActiveMetadata::Watcher.create! :model_class => "Document", :label => :date, :owner_id => @user.id
      @document.date = ""
      @document.save
      @document.notifier.should be_nil
      @document.history_for(:date).should be_empty
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
      @document.history_for(:name).last.model_id.should eq @document.id

      @section.history_for(:title).count.should eq(1)
      @section.history_for(:title).last.model_id.should eq @document.id
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

  describe "skip_history_notification" do

    context "given an user that watch Document#name" do

      before do
        @user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith')
        ActiveMetadata::Watcher.create! :model_class => "Document", :label => :name, :owner_id => @user.id
      end

      it "and skip_history_notification false creating a Document with name not null should save the history and generate a notification" do
        @document = Document.create! name: "John"
        @document.history_for(:name)[0].value.should eq(@document.name)
        @document.notifier.should_not be_nil
      end

      it "when true creating a Document with name not null should save the history but do not generate any notification" do
        @document = Document.create! name: "John", skip_history_notification: true
        @document.history_for(:name)[0].value.should eq(@document.name)
        @document.notifier.should be_nil
      end

    end

    context "given an user that watch Author#name (does not persist ancestor)" do

      before do
        @user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith')
        ActiveMetadata::Watcher.create! :model_class => "Author", :label => :name, :owner_id => @user.id
      end

      it "when a new record is craeted by the parent document instance should save history and generate a notification" do
        @document = Document.create! name: "John"
        @author = @document.create_author name: "my title"
        @author.history_for(:name)[0].value.should eq(@author.name)
        @author.notifier.should_not be_nil
      end

      it "when a new record is craeted by the parent document skipping notifications should save history and not generate any notification" do
        @document = Document.create! name: "John"
        @author = @document.create_author name: "my title", skip_history_notification: true
        @author.history_for(:name)[0].value.should eq(@author.name)
        @author.notifier.should be_nil
      end

    end

  end


end