require "spec_helper"
require "rack/test/uploaded_file"
require "time"

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
      @document.notes_for(:name).last.note.should eq "Very important note!"
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

    it "should verify that note are saved with the correct model id if metadata_id_from is defined"  do
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
      
      @document.delete_note_for(:name,notes[0].id)
      
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
      
      match_note = @document.note_for :name,id
      match_note.id.should eq id 
      
    end

    it "should has_notes_for verify if defined field has notes" do
      @document.has_notes_for(:name).should be_false
      @document.create_note_for(:name, "new note")
      @document.has_notes_for(:name).should be_true      
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

  context "attachments" do

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      doc = File.expand_path('../support/pdf_test.pdf',__FILE__)
      @attachment = Rack::Test::UploadedFile.new(doc, "application/pdf")
      doc2 = File.expand_path('../support/pdf_test_2.pdf',__FILE__)
      @attachment2 = Rack::Test::UploadedFile.new(doc2, "application/pdf")
    end

    it "should save attachment for a given attribute" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).should have(1).record
    end

    it "should verify that the attachment metadata id refers to the correct self id" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).last.document_id.should eq @document.id
    end

    it "should verify that the attachment file name is correctly saved" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).last.attach.original_filename.should eq @attachment.original_filename
    end

    it "should verify that the attachment content type is correctly saved" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).last.attach.content_type.should eq @attachment.content_type
    end

    it "should verify that the attachment size is correctly saved" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).last.attach.size.should eq @attachment.size
    end

    it "should verify that the attachment updated_at is correctly saved"  do
      @document.save_attachment_for(:name,@attachment)      
      @document.attachments_for(:name).last.attach.instance_read(:updated_at).should be_a_kind_of Time
    end

    it "should verify that the document has been saved in the correct position on filesystem"  do
      @document.save_attachment_for(:name,@attachment)
      att = @document.attachments_for(:name).first
      expected_path = File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{@document.id}/#{:name.to_s}/#{att.id}/#{@attachment.original_filename}"
      File.exists?(expected_path).should be_true
    end

    it "should delete an attachment by id" do
      #fixtures
      2.times do |i|
        @document.save_attachment_for(:name,@attachment)
      end

      #expectations
      attachments = @document.attachments_for(:name)
      attachments.count.should eq 2
      attachment_path_to_be_deleted = attachments[0].attach.path
      
      @document.delete_attachment_for(:name,attachments[0].id)
      
      attachments = @document.attachments_for(:name)
      attachments.count.should eq 1
      attachments.first.attach.path.should_not eq attachment_path_to_be_deleted
    end

    it "should update an attachment" do
      @document.save_attachment_for(:name,@attachment)
      att = @document.attachments_for(:name).last
      @document.update_attachment_for :name,att.id,@attachment2
      att2 = @document.attachments_for(:name).last

      File.exists?(att.attach.path).should be_false
      File.exists?(att2.attach.path).should be_true
    end

    it "should verify that field attachment_updated_at is modified after an update" do
      @document.save_attachment_for(:name,@attachment)
      att = @document.attachments_for(:name).last

      sleep 1.seconds

      @document.update_attachment_for :name,att.id,@attachment2
      att2 = @document.attachments_for(:name).last

      att2.attach.instance_read(:updated_at).should be > att.attach.instance_read(:updated_at)
    end
    
    it "should verify that is possible to upload 2 files with the same name for the same field" do
      2.times do
        @document.save_attachment_for(:name,@attachment)
      end  
      
      #expectations
      attachments = @document.attachments_for :name
      attachments.count.should eq 2
      File.exists?(attachments[0].attach.path).should be_true
      attachments[0].attach.instance_read(:file_name).should eq "pdf_test.pdf"
      File.exists?(attachments[1].attach.path).should be_true
      attachments[1].attach.instance_read(:file_name).should eq "pdf_test.pdf"
    end

    it "should save the correct creator when an attachment is created" do
      @document.save_attachment_for(:name,@attachment)
      @document.attachments_for(:name).last.created_by.should eq User.current.id
    end

    it "should save the correct updater when anttachment is updated" do
      @document.save_attachment_for(:name,@attachment)
      att = @document.attachments_for(:name).last

      @document.update_attachment_for :name,att.id,@attachment2
      att2 = @document.attachments_for(:name).last
      
      @document.attachments_for(:name).last.updated_by.should eq User.current.id        
    end

    it "should has_notes_for verify if defined field has attachments" do
      @document.has_attachments_for(:name).should be_false
      @document.save_attachment_for(:name,@attachment)
      @document.has_attachments_for(:name).should be_true      
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
