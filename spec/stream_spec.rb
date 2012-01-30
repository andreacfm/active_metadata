require "spec_helper"

describe Stream do

  describe "class" do

    it "should have a stream method" do
      Stream.should respond_to(:stream_for)
    end

    it "should know what is streamable" do
      Stream.instance_eval do
        @streamables.should == ActiveMetadata::CONFIG['streamables']
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

      describe "collect_data" do

        it "should return an array" do
          res = Stream.send(:collect_data)
          res.should be_kind_of Array
        end

        it "should return an array containing 4 items" do
          res = Stream.send(:collect_data)
          res.size.should == 4
        end


      end



    end

  end


end
