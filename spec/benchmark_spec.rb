require "spec_helper"
require "rack/test/uploaded_file"
require "benchmark"

describe "ActiveMetadata" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end
  
  context "running on mongo" do

    it "should insert 1000 notes" do
      Benchmark.bm do |x|
        x.report do
          1000.times do |i|
            @document.create_note_for(:name, "Note number #{i}")
          end
        end  
      end  
      @document.notes_for(:name).count.should eq 1000
    end
  
 end
 
end


