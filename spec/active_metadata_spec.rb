require "spec_helper"

describe ActiveMetadata do
  
  # pr = pratica.create :name => 'Andrea'
  # 
  # pr.name_create_nota ('nota') # crea una nuova nota
  # pr.name_note.should have(1).record
  # 
  # pr.nome_history
  # pr.nome_note
  
  context "it should be true" do
      it "should be true" do
        act_as_metadata.should be_nil
      end
  end
end