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
  end
end
