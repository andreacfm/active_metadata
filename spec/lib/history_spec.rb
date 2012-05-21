require "spec_helper"
require "time"

describe ActiveMetadata do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end

  describe "history" do

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

end