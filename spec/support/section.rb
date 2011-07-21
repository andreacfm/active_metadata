# encoding: utf-8
class Section < ActiveRecord::Base
  set_table_name :sections
  belongs_to :document

  acts_as_metadata :metadata_id_from => [:document]

end