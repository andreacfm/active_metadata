require "spec_helper"

describe ActiveMetadata do

  context "model methods" do

    it "should exist a method acts_as_metadata in the model" do
      Document.respond_to?(:acts_as_metadata).should be_true
    end

  end

  context "saving and quering notes" do

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
    end

    it "should create a new note for a given field" do
      @document.create_note_for(:name, "Very important note!")
      @document.notes_for(:name).should have(1).record
    end

    it "should verify the content of a note created" do
      @document.create_note_for(:name, "Very important note!")
      @document.notes_for(:name).last["note"].should eq "Very important note!"
    end

    it "should verify that notes_for_name return only notes for the self Document" do
      # fixtures
      @another_doc = Document.create :name => "Andrea"
      @another_doc.create_note_for(:name, "Very important note for doc2!")
      @another_doc.reload
      @document.create_note_for(:name, "Very important note!")

        # expectations
      @document.notes_for(:name).count.should eq(1)
      @document.notes_for(:name).last["note"].should eq "Very important note!"
      @another_doc.notes_for(:name).last["note"].should eq "Very important note for doc2!"

    end

    it "should update a note using update_not_for_name" do
      @document.create_note_for(:name, "Very important note!")
      id = @document.notes_for(:name).last["_id"]
      @document.update_note(id, "New note value!")
      @document.notes_for(:name).last["note"].should eq "New note value!"
    end

    it "should verify the content of a note created for a second attribute" do
      @document.create_note_for(:name, "Very important note!")
      @document.create_note_for(:surname, "Note on surname attribute!")

      @document.notes_for(:name).last["note"].should eq "Very important note!"
      @document.notes_for(:surname).last["note"].should eq "Note on surname attribute!"
    end

    it "should save multiple notes" do
      notes = ["note number 1", "note number 2"]
      @document.create_notes_for(:name, notes)
      @document.notes_for(:name).should have(2).record
      @document.notes_for(:name)[0]["note"].should eq "note number 1"
      @document.notes_for(:name)[1]["note"].should eq "note number 2"
    end

    it "should save the creator id in metadata" do
      @document.create_note_for(:name, "Very important note!", "current_user")
      @document.notes_for(:name).last["created_by"].should eq "current_user"
    end

    it "should save the updater id in metadata" do
      @document.create_note_for(:name, "Very important note!", "current_user")
      id = @document.notes_for(:name).last["_id"]
      @document.update_note id, "new note value", "another_user"
      @document.notes_for(:name).last["updated_by"].should eq "another_user"
    end

    it "should save the created_at datetime in metadata" do
      @document.create_note_for(:name, "Very important note!")
      @document.notes_for(:name).last["created_at"].should be_a_kind_of Time
    end

    it "should save the updated_at datetime in metadata" do
      @document.create_note_for(:name, "Very important note!")
      @document.notes_for(:name).last["updated_at"].should be_a_kind_of Time
    end

    it "should update the updated_at field when a note is updated" do
      @document.create_note_for(:name, "Very important note!")
      id = @document.notes_for(:name).last["_id"]
      sleep 0.1.seconds
      @document.update_note id, "new note value"
      note = @document.notes_for(:name).last
      note["updated_at"].should > note["created_at"]
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
      @document.history_for(:name)[0]["value"].should eq(@document.name)
    end

    it "should save the craeted_at datetime anytime an history entry is created" do
      @document.history_for(:name)[0]["created_at"].should be_a_kind_of Time
    end

    it "should verify that hsitory for only return history related to the self document" do
      # fixtures
      @another_doc = Document.create :name => "Andrea"
      @another_doc.reload

        # expectations
      @document.history_for(:name).count.should eq(1)
      @another_doc.history_for(:name).count.should eq(1)

      @document.history_for(:name).last["value"].should eq @document.name
      @another_doc.history_for(:name).last["value"].should eq @another_doc.name
    end


  end

end
