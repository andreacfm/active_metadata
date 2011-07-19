module Metadata
  
  #configurato da initilizer  
  #crea e mantiene la Mongo instance
    
end

class Pratica
  
  act_as_metadata  
     
  # tipo A
  def name_create_nota (nota)
    salvo la nota
  end    
  
  def name_update_nota (id,nota)
    aggiorno una nota
  end
  
  def name_note    
    ritorno tutte le note
  end  

  def name_note=(note)
    setto array di note    
  end  
  
  alias attachment
  
  scrive su collection => note
  
  
  #tipo B history
  after_save => :persists_history
  
  def persists_history
    prende il delta e chiama i metodi per nome  
  end  
  
  def name_create_history
    salvo la nota
  end    
  
end

pr = pratica.create :name => 'Andrea'

pr.name_create_nota ('nota') # crea una nuova nota
pr.name_note.should have(1).record

pr.nome_history
pr.nome_note


#routes
#POST
/pratiche/:pratica_id/:field/note
/pratiche/:pratica_id/:field/attachments

#PUT
/pratiche/:pratica_id/:field/note
/pratiche/:pratica_id/:field/attachments

#GET
/pratiche/:pratica_id/note
/pratiche/:pratica_id/attachments




