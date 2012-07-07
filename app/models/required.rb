class Required < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :course
end
