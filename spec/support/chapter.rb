# encoding: utf-8
class Chapter < ActiveRecord::Base
  acts_as_metadata ancestors: [:sections, :document]
  has_many :sections
end