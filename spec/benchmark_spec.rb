require "spec_helper"
require "rack/test/uploaded_file"
require "benchmark"

describe "ActiveMetadata" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end
  
  context "running on mongo" do

    it "should insert xxx notes" do
      notes = 1000000
      result = []
      Benchmark.bm do |x|
        x.report do
          notes.times do |i|
            start = Time.now
            @document.create_note_for(:name, "Note number #{i}")
            result.push Time.now - start
          end
        end  
      end  
      puts "Total = #{result.sum}"
      puts "Average = #{result.sum / notes}"
      @document.notes_for(:name).count.should eq notes
    end
  
 end
 
end


