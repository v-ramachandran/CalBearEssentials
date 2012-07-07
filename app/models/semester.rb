require 'plannable_mod'

class Semester < ActiveRecord::Base
  #attr_accessible :semester, :year
  include PlannableMod
  has_many :users
  has_many :planners

  def get_label
    semester + " " +  year.to_s
  end
end
