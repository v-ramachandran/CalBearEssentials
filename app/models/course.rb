require 'plannable_mod'

class Course < ActiveRecord::Base
  include PlannableMod
  has_many :required
  has_many :requirements, :through => :required
end
