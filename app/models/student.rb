require 'plannable_mod'

class Student < User
  include PlannableMod
  has_many :courses, :through => :planners
  belongs_to :semester, :foreign_key => "started_at" # Student has a start semester
  belongs_to :degree # Student is affiliated to one Degree...at least for now

  def self.create_from_registration(details, uid)

    create! do |student|
      student.uid = uid
      student.first_name = details["first_name"]
      student.last_name = details["last_name"]
      student.email = details["email"]
      student.degree = Degree.find_by_id( details["degree"])
      student.started_at =
        Semester.find_by_semester_and_year(details["start_semester"],
                                           details["start_year"])
    end

  end

  # Return False if first_name
  def self.valid_form?(details)
    return false if
      (details["first_name"].empty? or
       details["last_name"].empty? or
       details["email"].empty? or
       not(details["email"] =~ /@.*\./))
    logger.debug("REACHED HERE!")
    return true
  end

end
