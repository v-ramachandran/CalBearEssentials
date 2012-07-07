
class User < ActiveRecord::Base
  # If you're surprised that there's no code here its because
  # Single-Table-Inheritence is used to distinguish between different kinds
  # of users. Look at student.rb to see methods specific to Students.
end
