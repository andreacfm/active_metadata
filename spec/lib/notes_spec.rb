require "spec_helper"
require "time"

describe ActiveMetadata do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
  end

  describe "notes" do

    context "saving and quering" do

      it "should create a new note for a given field" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).should have(1).record
      end


      it "should verify the content of a note created" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).last.note.should eq "Very important note!"
      end

      it "should verify that notes are created for the correct model" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).last.document_class.should eq(@document.class.to_s)
      end

      it "should verify the created_by of a note created" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).last.created_by.should eq User.current.id
      end

      it "should verify that notes_for_name return only notes for the self Document" do
        # fixtures
        @another_doc = Document.create :name => "Andrea"
        @another_doc.create_note_for(:name, "Very important note for doc2!")
        @another_doc.reload
        @document.create_note_for(:name, "Very important note!")

        # expectations
        @document.notes_for(:name).count.should eq(1)
        @document.notes_for(:name).last.note.should eq "Very important note!"
        @another_doc.notes_for(:name).last.note.should eq "Very important note for doc2!"

      end

      it "should update a note using update_note_for_name" do
        @document.create_note_for(:name, "Very important note!")
        id = @document.notes_for(:name).last.id
        @document.update_note(id, "New note value!")
        @document.notes_for(:name).last.note.should eq "New note value!"
      end

      it "should verify the content of a note created for a second attribute" do
        @document.create_note_for(:name, "Very important note!")
        @document.create_note_for(:surname, "Note on surname attribute!")

        @document.notes_for(:name).last.note.should eq "Very important note!"
        @document.notes_for(:surname).last.note.should eq "Note on surname attribute!"
      end

      it "should save multiple notes" do
        notes = ["note number 1", "note number 2"]
        @document.create_notes_for(:name, notes)
        @document.notes_for(:name).should have(2).record
      end

      it "should save the updater id in metadata" do
        @document.create_note_for(:name, "Very important note!")
        id = @document.notes_for(:name).last.id
        @document.update_note id, "new note value"
        @document.notes_for(:name).last.updated_by.should eq User.current.id
      end

      it "should save the created_at datetime in metadata" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).last.created_at.should be_a_kind_of Time
      end

      it "should save the updated_at datetime in metadata" do
        @document.create_note_for(:name, "Very important note!")
        @document.notes_for(:name).last.updated_at.should be_a_kind_of Time
      end

      it "should update the updated_at field when a note is updated" do
        @document.create_note_for(:name, "Very important note!")
        id = @document.notes_for(:name).last.id
        sleep 1.seconds
        @document.update_note id, "new note value"
        note = @document.notes_for(:name).last
        note.updated_at.should > note.created_at
      end

      it "should verify that note are saved with the correct model id if metadata_id_from is defined" do
        # fixtures
        @document.create_note_for(:name, "Very important note!")
        @section = @document.create_section :title => "new section"
        @section.reload
        @section.create_note_for(:title, "Very important note for section!")

        # expectations
        @document.notes_for(:name).last.document_id.should eq @document.id
        @section.notes_for(:title).last.document_id.should eq @document.id
      end

      it "should delete a note id" do
        #fixtures
        2.times do |i|
          @document.create_note_for(:name, "Note number #{i}")
        end

        #expectations
        notes = @document.notes_for(:name)
        notes.count.should eq 2
        note_to_be_deleted = notes[0].note

        @document.delete_note(notes[0].id)

        notes = @document.notes_for(:name)
        notes.count.should eq 1
        notes.first.note.should_not eq note_to_be_deleted

      end

      it "should verify that notes_for sort by updated_at descending" do
        #fixtures
        3.times do |i|
          sleep 1.seconds
          @document.create_note_for(:name, "Note number #{i}")
        end

        #expectations
        @document.notes_for(:name).first.note.should eq "Note number 2"
        @document.notes_for(:name).last.note.should eq "Note number 0"
      end

      it "should find a note by id" do

        3.times do |i|
          @document.create_note_for(:name, "Note number #{i}")
        end

        note = @document.notes_for(:name).last
        id = note.id

        match_note = @document.find_note_by_id id
        match_note.id.should eq id

      end

      it "should has_notes_for verify if defined field has notes" do
        @document.has_notes_for(:name).should be_false
        @document.create_note_for(:name, "new note")
        @document.has_notes_for(:name).should be_true
      end

    end

    describe "managing starred" do

      it "should craete starred note" do
        @document.create_note_for(:name, "nuova nota", true)
        @document.notes_for(:name).first.starred?.should be_true
      end

      it "should update a note as starred" do
        @document.create_note_for(:name, "nuova nota")
        note = @document.notes_for(:name).first
        @document.update_note(note.id, note.note, starred: true)
        @document.notes_for(:name).first.starred?.should be_true
      end

      it "should retrieve only starred notes for a given label" do
        @document.create_note_for(:name, "starred note", true)
        @document.create_note_for(:name, "nuova nota")

        notes = @document.starred_notes_for(:name)
        notes.size.should eq 1
        notes.first.note.should eq "starred note"
      end

      it "should set a note as starred using star method" do
        @document.create_note_for(:name, "nota 1")
        nota = @document.notes_for(:name).first

        @document.star_note(nota.id)

        nota = @document.find_note_by_id(nota.id)
        nota.starred?.should be_true
      end

      it "should unstar a note" do
        @document.create_note_for(:name, "nota 1", true)
        nota = @document.notes_for(:name).first

        @document.unstar_note(nota.id)

        nota = @document.find_note_by_id(nota.id)
        nota.starred?.should be_false
      end

      context "when starring a note" do

        it "should send a notification of type star_note_message" do
          #watch
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          # create note and star it
          @document.create_note_for(:name, "nota 1")
          nota = @document.notes_for(:name).first
          @document.star_note(nota.id)
          @document.notifier.type.should eq :star_note_message
        end

      end

      context "when unstarring a note" do

        it "should send a notification of type unstar_note_message" do
          #watch
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          # create note and unstar it
          @document.create_note_for(:name, "nota 1")
          nota = @document.notes_for(:name).first
          @document.unstar_note(nota.id)
          @document.notifier.type.should eq :unstar_note_message
        end

      end

    end

    describe "#starred_notes" do

      it "should return all the starred notes for any model field" do
        @document.create_note_for :name, "starred note for name", true
        @document.create_note_for :title, "starred note for title", true
        @document.create_note_for :title, "not starred note for title"

        starred = @document.starred_notes
        starred.count.should eq 2
        starred.find{|note| note.note == "not starred note for title"}.should be_nil
      end

    end
    describe "#group" do
      it "should save the associated group when specified" do
        @document.create_note_for :name, "starred note for name", false, 'my_group'
        @document.notes_for(:name).last.group.should eq 'my_group'
      end

      describe "notes_by_group" do
        it "should return all the starred notes of a particular group" do
          @document.create_note_for :name, "starred note for name", false, 'my_group'
          @document.create_note_for :title, "to be returned", true, 'my_group'
          @document.create_note_for :name, "to be returned", true, 'my_group'
          @document.create_note_for :name, "starred note for name", false, 'your_group'
          @document.create_note_for :name, "starred note for name", true, 'your_group'

          ActiveMetadata::Note.by_group('my_group', :starred => true).count.should eq 2
          ActiveMetadata::Note.by_group('your_group', :starred => true, :order_by => "created_at ASC").count.should eq 1
        end
      end

    end

  end
end