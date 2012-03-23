require "spec_helper"

describe ActiveMetadata::Streamable do

  describe "module" do

    it "should respond to stream_for" do
      ActiveMetadata::Streamable.instance_eval do
        self.instance_methods.grep(/stream_for/).size.should == 1
      end
    end

  end

  describe "stream_for" do

    context "given 2 notes and 2 attachments" do

      before(:each) do
        @document = Document.create! { |d| d.name = "John" }
        @document.reload

        (1..2).each do |i|
          @document.save_attachment_for(:name,test_pdf("pdf_test_#{i}"))
          @document.create_note_for(:name, "note_#{i}")
        end
      end

      describe "stream_collect_method" do

        it "should return notes_for for Note class" do
          @document.send(:stream_collect_method, :note).should eq 'notes_for'
        end

        it "should return attachments_for for attachment class" do
          @document.send(:stream_collect_method, :attachment).should eq 'attachments_for'
        end

      end

      describe "collect_data" do

        it "should exists as private method" do
          ActiveMetadata::Streamable.instance_eval do
            self.private_instance_methods.grep(/collect_stream_data/).size.should == 1
          end
        end

        it "should return an array" do
          res = @document.send(:collect_stream_data, :name)
          res.should be_kind_of Array
        end

        it "should return an array containing notes and attachments" do
          res = @document.send(:collect_stream_data,:name)
          res.size.should == 4
          all_items_returened(res).should be_true
        end

        it "should return only the items referring to the request field" do
          @document.save_attachment_for(:surname,test_pdf("pdf_test_1"))
          @document.create_note_for(:surname, "surname note")
          res = @document.send(:collect_stream_data, :name)
          res.size.should == 4
          all_items_returened(res).should be_true
        end

      end

      describe "sort_stream" do

        it "should exists as private method" do
          ActiveMetadata::Streamable.instance_eval do
            self.private_instance_methods.grep(/sort_stream/).size.should == 1
          end
        end


        it "should sort the stream by updated_at DESC" do
          @document.save_attachment_for(:surname,test_pdf("pdf_test_1"))
          sleep 2.seconds
          @document.create_note_for(:surname, "surname note")
          sleep 2.seconds
          @document.save_attachment_for(:surname,test_pdf("pdf_test_2"))

          stream = @document.send(:collect_stream_data, :surname)
          res = @document.send(:sort_stream, stream, :updated_at)

          res[0].attach_file_name.should eq 'pdf_test_2.pdf'
          res[1].note.should eq 'surname note'
          res[2].attach_file_name.should eq 'pdf_test_1.pdf'
        end

        it "should sort the stream by updated_at DESC" do
          @document.create_note_for(:surname, "surname note")
          sleep 2.seconds
          @document.save_attachment_for(:surname,test_pdf("pdf_test_2"))
          sleep 2.seconds
          @document.save_attachment_for(:surname,test_pdf("pdf_test_1"))

          stream = @document.send(:collect_stream_data, :surname)
          res = @document.send(:sort_stream, stream, :created_at)

          res[0].attach_file_name.should eq 'pdf_test_1.pdf'
          res[1].attach_file_name.should eq 'pdf_test_2.pdf'
          res[2].note.should eq 'surname note'
        end

      end

      describe "stream_for" do

        it "should stream"  do
          res = @document.stream_for :name
          res.size.should == 4
          all_items_returened(res).should be_true
        end

      end

      # test that the res array contains the 4 elements created in this context
      def all_items_returened res
        return false unless res.dup.keep_if{|item| item.respond_to?(:note) && item.note == 'note_1'}.count == 1
        return false unless res.dup.keep_if{|item| item.respond_to?(:note) && item.note == 'note_2'}.count == 1
        return false unless res.dup.keep_if{|item| item.respond_to?(:attach_file_name) && item.attach_file_name == 'pdf_test_1.pdf'}.count == 1
        return false unless res.dup.keep_if{|item| item.respond_to?(:attach_file_name) && item.attach_file_name == 'pdf_test_2.pdf'}.count == 1
        true
      end

    end

  end


end
