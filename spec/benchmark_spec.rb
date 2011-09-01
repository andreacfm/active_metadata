require "spec_helper"
require "rack/test/uploaded_file"
require "benchmark"

describe "ActiveMetadata" do

  before(:each) do
    @document = Document.create! { |d| d.name = "John" }
    @document.reload
  end
  
  context "running on mongo" do

    it "should insert 500 notes" do
      result = []
      Benchmark.bm do |x|
        x.report do
          500.times do |i|
            start = Time.now
            @document.create_note_for(:name, "Note number #{i}")
            result.push Time.now - start
          end
        end  
      end  
      puts "Total = #{result.sum}"
      puts "Average = #{result.sum / 500}"
      @document.notes_for(:name).count.should eq 500
    end
  
 end
 
end


