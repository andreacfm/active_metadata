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
      Document.respond_to?(:act_as_metadata).should be_true
    end
                                   
    context "managing notes" do
      it "should respond to create_nota_for_name" do        
        pending
        @document.respond_to?(:create_nota_for_name).should be_true
      end

      it "should respond to update_nota_for_name" do       
        pending
        @document.respond_to?(:update_nota_for_name).should be_true      
      end      
      it "should respond to note_for_name" do       
        pending
        @document.respond_to?(:note_for_name).should be_true      
      end      
      it "should respond to note_for_name=" do       
        pending
        @document.respond_to?(:note_for_name=).should be_true      
      end      
      
      it "should create a new note for a give field" do
        pending
        @document.create_nota_for_name("Very important note!")
        @document.note_for_name.should have(1).record
      end
    end                     
  end
end
