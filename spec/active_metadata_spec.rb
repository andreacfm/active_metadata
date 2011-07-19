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
      @document = Document.create(:name => "John" )
    end

    it "should exist a method act_as_metadata in the model" do
      @document.respond_to?(:act_as_metadata).should be_true
    end
                                   
    context "managing notes" do
      it "should respond to name_create_nota" do       
        pending
        @document.respond_to?(:name_create_nota).should be_true      
      end

      it "should respond to name_update_nota" do       
        pending
        @document.respond_to?(:name_update_nota).should be_true      
      end      
      it "should respond to name_note" do       
        pending
        @document.respond_to?(:name_note).should be_true      
      end      
      it "should respond to name_note=" do       
        pending
        @document.respond_to?(:name_note=).should be_true      
      end      
      
      it "should create a new note for a give field" do
        pending
        @document.name_create_nota("Very important note!")
        @document.name_note.should have(1).record
      end
    end                     
  end
end
