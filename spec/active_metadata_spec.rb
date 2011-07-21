require "spec_helper"

describe ActiveMetadata do

  context "model methods" do

    it "should exist a method acts_as_metadata in the model" do
      Document.respond_to?(:acts_as_metadata).should be_true
    end

    it "should find the metadata id if no metadata_id_from params has been provided" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @document.metadata_id.should eq @document.id
    end

    it "should find the metadata id if a metadata_id_from params has been specified" do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      @section = @document.create_section :title => "new section"
      @section.reload
      @section.metadata_id.should eq @document.id
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

    it "should verify that note are saved with the correct model id if metadata_id_from is defined" do
      # fixtures
      @document.create_note_for(:name, "Very important note!")
      @section = @document.create_section :title => "new section"
      @section.reload
      @section.create_note_for(:title, "Very important note for section!")

      # expectations
      @document.notes_for(:name).last["id"].should eq @document.id
      @section.notes_for(:title).last["id"].should eq @document.id
    end

    it "should delete a note" do
      #fixtures
      3.times do |i|
        @document.create_note_for(:name, "Note number #{i}")
      end

      #expectations
      notes = @document.notes_for(:name)
      notes.count.should eq 3
      @document.delete_note(notes[0]["_id"])
      @document.notes_for(:name)
      @document.notes_for(:name).count.should eq 2

    end

    it "should verify that notes_for sort by updated_at descending" do
      #fixtures
      3.times do |i|
        sleep 0.1.seconds
        @document.create_note_for(:name, "Note number #{i}")
      end

      #expectations
      @document.notes_for(:name).first["note"].should eq "Note number 2"
      @document.notes_for(:name).last["note"].should eq "Note number 0"
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

    it "should verify that history return records only for the self document" do
      # fixtures
      @another_doc = Document.create :name => "Andrea"
      @another_doc.reload

        # expectations
      @document.history_for(:name).count.should eq(1)
      @another_doc.history_for(:name).count.should eq(1)

      @document.history_for(:name).last["value"].should eq @document.name
      @another_doc.history_for(:name).last["value"].should eq @another_doc.name
    end

    it "should verify that history is saved with the correct model id if metadata_id_from is defined" do
      # fixtures
      @section = @document.create_section :title => "new section"
      @section.reload

        # expectations
      @document.history_for(:name).count.should eq(1)
      @document.history_for(:name).last["id"].should eq @document.id

      @section.history_for(:title).count.should eq(1)
      @section.history_for(:title).last["id"].should eq @document.id
    end

    it "should verify that history_for sort by created_at descending" do
      #fixtures
      3.times do |i|
        sleep 0.1.seconds
        @document.name = "name #{i}"
        @document.save
      end

      #expectations
      @document.history_for(:name).first["value"].should eq "name 2"
      @document.history_for(:name).last["value"].should eq "John"
    end


  end

end
