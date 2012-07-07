require 'spec_helper'

describe Planner do

  describe "returning all courses per requirement basis" do

    before :all do
      # Mock all mockable objects
      # Courses, Planners
      @cs_199 = FactoryGirl.create(:course, :name => "CS_199",:abb => "cs", :units => 2)
      @cs_170 = FactoryGirl.create(:course, :name => "CS_170",:abb => "cs", :units => 4)
      @cs_150 = FactoryGirl.create(:course, :name => "CS_150",:abb => "cs", :units => 5)
      @cs_188 = FactoryGirl.create(:course, :name => "CS_188",:abb => "cs", :units => 4)
      @cs_194 = FactoryGirl.create(:course, :name => "CS_194",:abb => "cs", :units => 3)


      #Students
      @st1 = FactoryGirl.create(:student)
      @st2 = FactoryGirl.create(:student)
      @st3 = FactoryGirl.create(:student)

      #Requirements
      @ur1 = FactoryGirl.create(:unit_requirement, :units => 13, :name => "foo")
      @ur2 = FactoryGirl.create(:unit_requirement, :units => 10, :name => "bar")
      @ur3 = FactoryGirl.create(:unit_requirement, :units => 5, :name => "baz")

      @cr1 = FactoryGirl.create(:course_requirement, :units => 1, :name => "gar")
      @cr2 = FactoryGirl.create(:course_requirement, :units => 4, :name => "ply")
      @cr3 = FactoryGirl.create(:course_requirement, :units => 2, :name => "soo")

      #Planners
      @pp1 = PastPlanner.create do |p|
        p.user = @st1
        p.course = @cs_199
      end
      @pp2 = PastPlanner.create do |p|
        p.user = @st1
        p.course = @cs_188
      end
      @fp1 = FuturePlanner.create do |p|
        p.user = @st1
        p.course = @cs_170
      end
      @fp2 = FuturePlanner.create do |p|
        p.user = @st1
        p.course = @cs_150
      end
      @fp3 = FuturePlanner.create do |p|
        p.user = @st2
        p.course = @cs_150
      end

      @d1=FactoryGirl.create(:degree)
      @st1.degree=@d1
      @d2=FactoryGirl.create(:degree, :name => "CS")

      # Satisfieds
      Satisfied.create do |s|
        s.degree=@d1
        s.requirement=@ur1
      end

      Satisfied.create do |s|
        s.degree=@d1
        s.requirement=@ur2
      end

      Satisfied.create do |s|
        s.degree=@d1
        s.requirement=@cr1
      end

      # Requireds
      # Unit Requirements
      Required.create do |r|
        r.requirement=@ur1
        r.course=@cs_170
      end

      Required.create do |r|
        r.requirement=@ur1
        r.course=@cs_188
      end

      Required.create do |r|
        r.requirement=@ur1
        r.course=@cs_194
      end

      Required.create do |r|
        r.requirement=@ur1
        r.course=@cs_150
      end

      Required.create do |r|
        r.requirement=@ur2
        r.course=@cs_170
      end

      # Course Requirements
      Required.create do |r|
        r.requirement=@cr1
        r.course=@cs_170
      end

      Required.create do |r|
        r.requirement=@cr1
        r.course=@cs_188
      end

      Required.create do |r|
        r.requirement=@cr1
        r.course=@cs_194
      end

      Required.create do |r|
        r.requirement=@cr2
        r.course=@cs_150
      end

      Required.create do |r|
        r.requirement=@cr2
        r.course=@cs_170
      end

      @ur = Planner.find_unit_requirements_fulfilled(@st1)
      @cr = Planner.find_course_requirements_fulfilled(@st1)
      @cr_vals = @cr.values
      @ur_vals = @ur.values
      @cr_keys = @cr.keys
      @ur_keys = @ur.keys

    end

    it "should call a find by sql to obtain the necessary attributes" do
      Planner.should_receive(:find_by_sql).and_return([])
      Planner.find_unit_requirements_fulfilled(@st3)

      Planner.should_receive(:find_by_sql).and_return([])
      Planner.find_course_requirements_fulfilled(@st3)
    end

    describe "test when there are requirements in progress" do

      it "should group the elements by appropriate requirement name" do
        cr_keys = @cr.keys
        ur_keys = @ur.keys
        ur_keys.each do |key|
          UnitRequirement.find_by_name(key).should_not be_nil
        end
        cr_keys.each do |key|
          CourseRequirement.find_by_name(key).should_not be_nil
        end
      end

      it "should have a four element value for each key with the appropriate format" do
        cr_vals = @cr.values
        ur_vals = @ur.values

        ur_vals.each do |val|

          val.length.should == 4

          val[0].class.to_s.should == "Array"
          val[1].class.to_s.should == "Fixnum"
          (val[2].class.to_s =="TrueClass" || val[2].class.to_s == "FalseClass").should be_true
          val[3].class.to_s.should == "Fixnum"

        end

        cr_vals.each do |val|
          val.length.should == 4

          val[0].class.to_s.should == "Array"
          val[1].class.to_s.should == "Fixnum"
          (val[2].class.to_s =="TrueClass" || val[2].class.to_s == "FalseClass").should be_true
          val[3].class.to_s.should == "Fixnum"

        end
      end
    end

    describe "curious case of student 1" do

      it "should have passed unit requirements" do
        passed_req = @ur["foo"]
        passed_req[2].should be_true
      end

      it "should have accurate course names and units" do
        req_courses = @ur["foo"][0]

        req_courses.include?({"name" => "CS 170", "abb" => "cs", "units" => 4}).should be_true
        req_courses.include?({"name" => "CS 188", "abb" => "cs", "units" => 4}).should be_true
        req_courses.include?({"name" => "CS 194", "abb" => "cs", "units" => 3}).should be_false
        req_courses.include?({"name" => "CS 150", "abb" => "cs", "units" => 5}).should be_true

        req_courses.each do |course|
          q_c = Course.find_by_name_and_units(course["name"].gsub(" ","_"), course["units"])
          Planner.find_by_course_id(q_c).should_not be_nil
          q_r = Requirement.find_by_name("foo")
          Required.find_by_course_id_and_requirement_id(q_c.id, q_r.id).should_not be_nil
        end
      end

      it "should have 3 requirements" do
        @ur_keys.length.should == 3
      end

      it "should fail the other unit requirement" do
        passed_req = @ur["bar"]
        passed_req[2].should be_false
      end
    end

    it "should have empty course lists and false if student has not made any progress" do
      ur=Planner.find_unit_requirements_fulfilled(@st3)
      cr=Planner.find_course_requirements_fulfilled(@st3)
      
      ur.each do |key, value|
        value[0].should be_empty
        value[1].should == 0
        value[2].should be_false
      end
      cr.each do |key, value|
        value[0].should be_empty
        value[1].should == 0
        value[2].should be_false
      end
    end

    it "should have stuff if fulfilling requirements is in progress" do
      ur = Planner.find_unit_requirements_fulfilled(@st1)
      cr = Planner.find_course_requirements_fulfilled(@st1)
      ur.should_not be_empty
      cr.should_not be_empty

      ur.keys.should_not be_nil
      cr.keys.should_not be_nil
    end

  end

  describe "return all of a users planners sorted a certain way" do

    before :all do
      # TODO: Seed this into a test db

      # Create students
      @student = Student.create! #FactoryGirl.create(:student)
      @student2 = Student.create! #FactoryGirl.create(:student, :id=>2)

      # Create all necessary semesters
      @sem1 = Semester.create!(:semester => "Fall", :year => 2011)
      @sem2 = Semester.create!(:semester => "Spring", :year => 2011)
      @sem3 = Semester.create!(:semester => "Summer", :year => 2011)

      # Create all necessary courses
      @cou1 = Course.create!(:name => "CS 199")
      @cou2 = Course.create!(:name => "EE 122")
      @cou3 = Course.create!(:name => "EE 199")

      # Create some planner entries
      @plan1 = Planner.create! do |p|
        p.course = @cou1
        p.semester = @sem1
        p.user = @student2
      end

      @plan2 = Planner.create! do |p|
        p.course = @cou2
        p.semester = @sem1
        p.user = @student2
      end

      @plan3 = Planner.create! do |p|
        p.course = @cou3
        p.semester = @sem2
        p.user = @student2
      end

      #create degrees
      @degree = Degree.create!
      @student.degree_id = @degree.id
      @student2.degree_id = @degree.id

      #create requirements
      @req1 = Requirement.create!
      @req2 = Requirement.create!

      #create requirement-degree associations
      Satisfied.create! do |s|
        s.requirement_id = @req1.id
        s.degree_id = @degree.id
      end

      Satisfied.create! do |s|
        s.requirement_id = @req2.id
        s.degree_id = @degree.id
      end

      #create requirement-course associations
      Required.create! do |r|
        r.requirement_id = @req1.id
        r.course_id = @cou1.id
      end

      Required.create! do |r|
        r.requirement_id = @req2.id
        r.course_id = @cou2.id
      end

      Required.create! do |r|
        r.requirement_id = @req1.id
        r.course_id = @cou3.id
      end

    end

    describe "find all user planners function()" do
      it "should call a user id based finder" do
        Planner.should_receive(:find_all_by_user_id).with(@student.id).and_return([])
        Planner.find_all_user_planners(@student)
      end

      it "should return empty list if no planners are found for the user" do
        rtn=Planner.find_all_user_planners(@student)
        rtn.should be_empty
      end

      it "should return nonempty stuff if planner stuff exists" do
        rtn=Planner.find_all_user_planners(@student2)
        rtn.should_not be_empty
        rtn.length.should == 2
      end

      it "should prepare a list of keys for each semester" do
        rtn = Planner.find_all_user_planners(@student2)
        keys = rtn.keys
        keys.length.should == 2
        keys.include?(@sem1.get_label).should be_true
        keys.include?(@sem2.get_label).should be_true
        keys.include?(@sem3.get_label).should be_false
      end
    end

    describe "find_all_semester_groups function ()" do
      it "should call find_all_user_planners" do
        Planner.should_receive(:find_all_user_planners).with(@student).and_return({})
        Planner.find_all_semester_groups(@student)
      end

      it "should return a duple of sorted keys and the grouped by semester hash from find_all_user_planners" do
        rtn = Planner.find_all_semester_groups(@student2)
        rtn.length.should == 2

        keys = rtn[0]
        keys.should == ["Spring 2011", "Fall 2011"]

        sem_hash = rtn[1]
        sem_hash.length.should == 2
      end
    end

    describe "return all of a users planners that satisfy a degree requirement" do
      it "should call find_all_by_user_id" do
        Planner.should_receive(:find_all_by_user_id).with(@student.id).and_return({})
        Planner.find_required_courses_by_degree(@student)
      end
      it "should return a duple of a sorted keys and the semester hash filterd and grouped by requirements" do
        rtn = Planner.find_required_courses_by_degree(@student2)
        rtn.length.should == 2

        keys = rtn[0]
        keys.should == [@req1, @req2]

        req_hash = rtn[1]
        req_hash.length.should == 2
        req_hash[@req1].should == [@plan1, @plan3]
        req_hash[@req2].should == [@plan2]
      end
    end
  end


  after :all do
    Semester.delete_all
    Planner.delete_all
    Student.delete_all
    Degree.delete_all
    Requirement.delete_all
    Required.delete_all
    Satisfied.delete_all
    Course.delete_all
  end
end
