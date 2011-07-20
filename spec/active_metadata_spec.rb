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

    it "should exist a method act_as_metadata in the model" do
      Document.respond_to?(:act_as_metadata).should be_true
    end

    context "managing notes" do

      before(:each) do
        @document = Document.create(:name => "John")
      end

      it "should respond to create_note_for_name" do
        @document.respond_to?(:create_note_for_name).should be_true
      end

      it "should respond to update_note_for_name" do
        @document.respond_to?(:update_note_for_name).should be_true
      end

      it "should respond to notes_for_name" do
        @document.respond_to?(:notes_for_name).should be_true
      end

      it "should respond to notes_for_name=" do
        @document.respond_to?(:notes_for_name=).should be_true
      end

      it "should create a new note for a given field" do
        @document.create_note_for_name("Very important note!")
        @document.notes_for_name.should have(1).record
      end

      it "should verify the content of a note created" do
        @document.create_note_for_name("Very important note!")
        @document.notes_for_name.last["note"].should eq "Very important note!"
      end

    end
  end
end
