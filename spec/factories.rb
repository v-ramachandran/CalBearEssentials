Factory.define :student , do |u|
  u.first_name 'TestSubject'
  u.last_name 'DoDo'
  u.username  'testSubject'
  u.provider 'Facebook'
  u.uid '1'
end

Factory.define :course, do |c|
  c.name 'TestCourse'
  c.department 'EECS'
  c.units '4'
  c.weight '1'
end

Factory.define :semester do |s|
  s.semester "Spring"
  s.year 2012
end

Factory.define :planner do |p|

  Factory.define :future_planner do |fp|
    fp.type "FuturePlanner"
  end
  Factory.define :past_planner do |pp|
    pp.type "PastPlanner"

  end
end

Factory.define :degree do |d|
  d.name "EECS"
end

Factory.define :requirement do |r|
  Factory.define :unit_requirement do |ur|
  end
  Factory.define :course_requirement do |cr|
  end
end

'''
Factory.define :planner do |p|
  Factory.define :future_planner do |fp|

    fp.type "FuturePlanner"

    Factory.define :semester_plannable, :parent =>:planner do |sp|
      sp.plannable { |plan| plan.association(:semester) }
    end
    Factory.define :user_plannable, :parent =>:planner do |sp|
      sp.plannable { |plan| plan.association(:user) }
    end
    Factory.define :course_plannable, :parent =>:planner do |sp|
      sp.plannable { |plan| plan.association(:course) }
    end

  end
  Factory.define :past_planner do |pp|
    pp.type "PastPlanner"
    Factory.define :semester_planned do |sp|
      sp.plannable { |plan| plan.association(:semester) }
    end
    Factory.define :user_planned do |sp|
      sp.plannable { |plan| plan.association(:user) }
    end
    Factory.define :course_planned do |sp|
      sp.plannable { |plan| plan.association(:course) }
    end
  end
end

Factory.define :base_user, :parent => :user do |user|
  user.after_create {|a| Factory(:user_plannable, :user => a)}
end
Factory.define :base_course, :parent => :course do |course|
  course.after_create {|c| Factory(:course_plannable, :course => c)}
end
Factory.define :base_semester, :parent => :semester do |semester|
  semester.after_create {|s| Factory(:semester_plannable, :semester => s)}
end
'''
