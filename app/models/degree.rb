class Degree < ActiveRecord::Base

  has_many :satisfieds
  has_many :requirements, :through => :satisfieds
  has_many :users
end
