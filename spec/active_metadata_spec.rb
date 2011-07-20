require "spec_helper"

describe ActiveMetadata do

  # pr = pratica.create :name => 'Andrea'
  #
  # pr.name_create_nota ('nota') # crea una nuova nota
  # pr.name_note.should have(1).record
  #
  # pr.nome_history
  # pr.nome_note

  context "model methods" do

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
    end

    it "should exist a method act_as_metadata in the model" do
      Document.respond_to?(:act_as_metadata).should be_true
    end

    context "saving and quering notes" do
      it "should create a new note for a given field" do
        @document.create_note_for(:name,"Very important note!")
        @document.notes_for(:name).should have(1).record
      end

      it "should verify the content of a note created" do
        @document.create_note_for(:name,"Very important note!")
        @document.notes_for(:name).last["note"].should eq "Very important note!"
      end

      it "should verify that notes_for_name return only notes for the self Document" do
        # fixtures
        @another_doc = Document.create :name => "Andrea"
        @another_doc.create_note_for(:name,"Very important note for doc2!")
        @another_doc.reload
        @document.create_note_for(:name,"Very important note!")

        # expectations
        @document.notes_for(:name).count.should eq(1)
        @document.notes_for(:name).last["note"].should eq "Very important note!"
        @another_doc.notes_for(:name).last["note"].should eq "Very important note for doc2!"

      end

      it "should update a note using update_not_for_name" do
        @document.create_note_for(:name,"Very important note!")
        id = @document.notes_for(:name).last["_id"]
        @document.update_note(id, "New note value!")
        @document.notes_for(:name).last["note"].should eq "New note value!"
      end

      it "should verify the content of a note created for a second attribute" do
        @document.create_note_for(:name,"Very important note!")
        @document.create_note_for(:surname,"Note on surname attribute!")

        @document.notes_for(:name).last["note"].should eq "Very important note!"
        @document.notes_for(:surname).last["note"].should eq "Note on surname attribute!"
      end

      it "should save multiple notes" do
        notes = ["note number 1","note number 2"]
        @document.create_notes_for(:name,notes)
        @document.notes_for(:name).should have(2).record
        @document.notes_for(:name)[0]["note"].should eq "note number 1"
        @document.notes_for(:name)[1]["note"].should eq "note number 2"
      end

      it "should save the creator id in metadata"
      it "should save the updater id in metadata"

      it "should save the created_at datetime in metadata" do
        @document.create_note_for(:name,"Very important note!")
        @document.notes_for(:name).last["created_at"].should be_a_kind_of Time
      end

      it "should save the updated_at datetime in metadata" do
        @document.create_note_for(:name,"Very important note!")
        @document.notes_for(:name).last["updated_at"].should be_a_kind_of Time
      end

      it "should update the updated_at field when a note is updated" do
        @document.create_note_for(:name,"Very important note!")
        id = @document.notes_for(:name).last["_id"]
        sleep 0.1.seconds
        @document.update_note id,"new note value"
        note = @document.notes_for(:name).last
        note["updated_at"].should > note["created_at"]
      end

    end
  end
end
