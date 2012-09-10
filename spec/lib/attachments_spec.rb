require "spec_helper"
require "rack/test/uploaded_file"
require "time"

describe ActiveMetadata do

  context "attachments" do

    before(:each) do
      @document = Document.create! { |d| d.name = "John" }
      @document.reload
      doc = File.expand_path('../../support/pdf_test.pdf', __FILE__)
      @attachment = Rack::Test::UploadedFile.new(doc, "application/pdf")
      doc2 = File.expand_path('../../support/pdf_test_2.pdf', __FILE__)
      @attachment2 = Rack::Test::UploadedFile.new(doc2, "application/pdf")
    end


    context "saving and quering" do

      it "should save attachment for a given attribute" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).should have(1).record
      end

      it "should verify that the attachment metadata id refers to the correct self id" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.model_id.should eq @document.id
      end

      it "should verify that the attachment file name is correctly saved" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.attach.original_filename.should eq @attachment.original_filename
      end

      it "should verify that the attachment content type is correctly saved" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.attach.content_type.should eq @attachment.content_type
      end

      it "should verify that the attachment size is correctly saved" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.attach.size.should eq @attachment.size
      end

      it "should verify that the attachment updated_at is correctly saved" do
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.attach.instance_read(:updated_at).should be_a_kind_of Time
      end

      it "should verify that the document has been saved in the correct position on filesystem" do
        @document.save_attachment_for(:name, @attachment)
        att = @document.attachments_for(:name).first
        expected_path = File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{att.model_class}/#{@document.id}/#{:name.to_s}/#{att.id}/#{@attachment.original_filename}"
        File.exists?(expected_path).should be_true
      end

      it "should delete an attachment by id" do
        #fixtures
        2.times do |i|
          @document.save_attachment_for(:name, @attachment)
        end

        #expectations
        attachments = @document.attachments_for(:name)
        attachments.count.should eq 2
        attachment_path_to_be_deleted = attachments[0].attach.path

        @document.delete_attachment(attachments[0].id)

        attachments = @document.attachments_for(:name)
        attachments.count.should eq 1
        attachments.first.attach.path.should_not eq attachment_path_to_be_deleted
      end

      it "should update an attachment" do
        @document.save_attachment_for(:name, @attachment)
        att = @document.attachments_for(:name).last
        @document.update_attachment att.id, @attachment2
        att2 = @document.attachments_for(:name).last

        File.exists?(att.attach.path).should be_false
        File.exists?(att2.attach.path).should be_true
      end

      it "should verify that field attachment_updated_at is modified after an update" do
        @document.save_attachment_for(:name, @attachment)
        att = @document.attachments_for(:name).last

        sleep 1.seconds

        @document.update_attachment att.id, @attachment2
        att2 = @document.attachments_for(:name).last

        att2.attach.instance_read(:updated_at).should be > att.attach.instance_read(:updated_at)
      end

      it "should verify that is possible to upload 2 files with the same name for the same field" do
        2.times do
          @document.save_attachment_for(:name, @attachment)
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
        @document.save_attachment_for(:name, @attachment)
        @document.attachments_for(:name).last.created_by.should eq User.current.id
      end

      it "should save the correct updater when anttachment is updated" do
        @document.save_attachment_for(:name, @attachment)
        att = @document.attachments_for(:name).last

        @document.update_attachment att.id, @attachment2
        att2 = @document.attachments_for(:name).last

        @document.attachments_for(:name).last.updated_by.should eq User.current.id
      end

      it "should has_notes_for verify if defined field has attachments" do
        @document.has_attachments_for(:surname).should be_false
        @document.save_attachment_for(:surname, @attachment)
        @document.has_attachments_for(:surname).should be_true
      end

    end

    describe "managing starred" do

      it "should craete starred attachments" do
        @document.save_attachment_for(:name, @attachment, true)
        @document.attachments_for(:name).first.starred?.should be_true
      end

      it "should update an attachment as starred" do
        @document.save_attachment_for(:name, @attachment)
        attachment = @document.attachments_for(:name).first
        @document.update_attachment(attachment.id, attachment.attach, starred: true)
        @document.attachments_for(:name).first.starred?.should be_true
      end

      it "should retrieve only starred attachments for a given label" do
        @document.save_attachment_for(:name, @attachment, true)
        @document.save_attachment_for(:name, @attachment2)

        atts = @document.starred_attachments_for(:name)
        atts.size.should eq 1
      end

      it "should set an attachment as starred using star method" do
        @document.save_attachment_for(:name, @attachment2)
        att = @document.attachments_for(:name).first

        @document.star_attachment(att.id)

        att = @document.find_attachment_by_id(att.id)
        att.starred?.should be_true
      end

      it "should unstar" do
        @document.save_attachment_for(:name, @attachment, true)
        att = @document.starred_attachments_for(:name).first

        @document.unstar_attachment(att.id)

        att = @document.find_attachment_by_id(att.id)
        att.starred?.should be_false
      end

      context "when starring" do

        it "should send a notification of type star_attachment_message" do
          #watch
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          # create note and star it
          @document.save_attachment_for(:name, @attachment, true)
          att = @document.attachments_for(:name).first

          @document.star_attachment(att.id)
          @document.notifier.type.should eq :star_attachment_message
        end

      end

      context "when unstarring" do

        it "should send a notification of type unstar_attachment_message" do
          #watch
          user = User.create!(:email => "email@email.it", :firstname => 'John', :lastname => 'smith' )
          @document.create_watcher_for(:name, user)
          # create note and star it
          @document.save_attachment_for(:name, @attachment, true)
          att = @document.attachments_for(:name).first

          @document.unstar_attachment(att.id)
          @document.notifier.type.should eq :unstar_attachment_message
        end

      end


    end

    describe "#starred_attachments" do

      it "should return all the starred attachments for any model field" do
        @document.save_attachment_for(:name, @attachment, true)
        @document.save_attachment_for(:title, @attachment, true)
        @document.save_attachment_for(:title, @attachment2 )

        starred = @document.starred_attachments
        starred.count.should eq 2
        starred.find{|att| att.attach.instance_read(:file_name) == "pdf_test_2.pdf"}.should be_nil
      end
    end

    describe "#group" do
      it "should save the associated group when specified" do
        @document.save_attachment_for(:name, @attachment, false, 'my_group')
        @document.attachments_for(:name).last.group.should eq 'my_group'
      end

      describe ".by_group" do

        it "should return all the starred notes of a particular group" do
          @document.save_attachment_for :name, @attachment, false, 'my_group'
          @document.save_attachment_for :title, @attachment, true, 'my_group'
          @document.save_attachment_for :name, @attachment, true, 'my_group'
          @document.save_attachment_for :name, @attachment, false, 'your_group'
          @document.save_attachment_for :name, @attachment, true, 'your_group'

          ActiveMetadata::Attachment.by_group('my_group', :starred => true).count.should eq 2
          ActiveMetadata::Attachment.by_group('your_group', :starred => true).count.should eq 1
        end
      end
    end
  end
end