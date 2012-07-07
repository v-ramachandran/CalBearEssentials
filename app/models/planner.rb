class Planner < ActiveRecord::Base
  belongs_to :user
  belongs_to :semester
  belongs_to :course

  # If user does not have any planners => return nil
  # If user has planners => group by semester, and return an array of hashes
  # where the array is sorted in chronological semester order, and each hash
  # has all the particular semester's planners
  def self.find_all_user_planners(user)
    all_planners = find_all_by_user_id(user.id)
    # The select command below makes sure that only planners with valid
    # semesters (i.e. semesters that exist in the database) are processed
    oded=all_planners.select{ |p| p.semester }.group_by do |elt|
      elt.semester.get_label
    end
  end

  def self.find_all_semester_groups(user)
    temp=find_all_user_planners(user)
    keys=temp.keys.sort{|a,b|
      seasons = {"Spring" => 0, "Summer" => 1, "Fall" => 2}
      a_temp=a.split
      b_temp=b.split
      a_sem=seasons[a_temp[0]]
      a_yr=a_temp[1]
      b_sem=seasons[b_temp[0]]
      b_yr=b_temp[1]

      if a_yr==b_yr
        a_sem <=> b_sem
      else
        a_yr <=> b_yr
      end
    }
    return [keys, temp]
  end

  def self.find_unit_requirements_fulfilled(user)
    req_sets=Planner.find_by_sql ["SELECT r.requirement_id AS reqt, p.course_id AS clazz FROM requirements r2, requireds r, satisfieds s, planners p WHERE  p.user_id=? AND s.degree_id=? AND s.requirement_id=r.requirement_id AND r.course_id=p.course_id AND r.requirement_id=r2.id AND r2.type='UnitRequirement'", user.id, user.degree_id]

    un_r=UnitRequirement.find(:all)
    un_r=un_r.map do |elt| 
      [elt.name.gsub("_"," "), elt.units]
    end
    req_groups=req_sets.group_by do |elt|
      Requirement.find_by_id(elt.reqt.to_i).name
    end
    ret_groups={}
    req_groups.each do |key, value|

      unit_count = 0
      req_course_ls = []

      value.each do |n|
        c = Course.find_by_id(n.clazz)
        unit_count += c.units
        req_course_ls << ({"name" => c.name.gsub("_"," "), "abb" => c.abb.gsub("_", " "), "units" => c.units})
      end

      needed_units = UnitRequirement.find_by_name(key).units

      passed=false
      if unit_count >= needed_units
        passed=true
      end
      ret_groups[key.gsub("_"," ")]=[req_course_ls, unit_count, passed, needed_units]
    end
  
    un_r.each do |elt|
      unless ret_groups.has_key? elt[0]
        ret_groups[elt[0]]=[[],0,false,elt[1]]
      end 
    end
    return ret_groups
  end

  def self.find_course_requirements_fulfilled(user)
    req_sets=Planner.find_by_sql ["SELECT r.requirement_id AS reqt, p.course_id AS clazz FROM requirements r2, requireds r, satisfieds s, planners p WHERE  p.user_id=? AND s.degree_id=? AND s.requirement_id=r.requirement_id AND r.course_id=p.course_id AND r2.id=r.requirement_id AND r2.type='CourseRequirement'", user.id, user.degree_id]

    co_r=CourseRequirement.find(:all)
    co_r=co_r.map do |elt| 
      [elt.name.gsub("_"," "), elt.units]
    end

    req_groups=req_sets.group_by do |elt|
      Requirement.find_by_id(elt.reqt.to_i).name
    end
    ret_groups={}
    req_groups.each do |key, value|

      course_count = 0
      req_course_ls = []

      value.each do |n|
        c = Course.find_by_id(n.clazz)
        course_count += 1
        req_course_ls << ({"name" => c.name.gsub("_"," "), "abb" => c.abb.gsub("_", " "), "units" => c.units})
      end

      needed_units = CourseRequirement.find_by_name(key).units

      passed=false
      if course_count >= needed_units
        passed=true
      end
      ret_groups[key.gsub("_"," ")]=[req_course_ls, course_count, passed, needed_units]
    end
    co_r.each do |elt|
      unless ret_groups.has_key? elt[0]
        ret_groups[elt[0]]=[[],0,false,elt[1]]
      end 
    end
    return ret_groups

    return ret_groups
  end

  def self.find_required_courses_by_degree(user)
    temp=find_all_by_user_id(user.id)                           #gets list of planners associated with user
    degree=user.degree_id                                       #gets degree id from user
    reqs=Satisfied.find_all_by_degree_id(degree)                #gets list of requirements for a degree
    keys=[]
    table = Hash.new
    reqs.each do |req|                                          #for each requirement
      requirement = req[:requirement_id]
      keys << Requirement.find(requirement)                                   #add as key
      cList=[]
      reqCourses=Required.find_all_by_requirement_id(requirement) #and find all courses that satisfy the requirement
      reqCourses.each do |reqCourse|                              #to search planners for those courses
        temp.each do |plan|
          if plan[:course_id] == reqCourse.course_id                 #if found add planner to planner course list for that requirement
            cList << plan
          end
        end
      end
      table[Requirement.find(requirement)]=cList                                       #and add that list to table
    end
    return [keys, table]
  end

  def self.test_method(req)
    Requirement.find_by_name(:foo_bar)
  end
end
