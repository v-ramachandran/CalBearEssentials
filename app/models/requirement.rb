class Requirement < ActiveRecord::Base
  has_many :satisfieds
  has_many :degrees, :through => :satisfieds
  has_many :requireds
  has_many :courses, :through => :requireds
end
