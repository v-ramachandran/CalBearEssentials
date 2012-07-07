require 'spec_helper'

describe Student do

  describe "create_from_registration method" do

    before :all do
      @degree=Degree.create!(:name => "EECS", :units => 165)
      @semester=Semester.create!(:semester => "Fall", :year => 2011)
      @details = {"first_name"=>"Lakers", "last_name"=>"2012Champions", "email"=>"lalchamps@nba.com", "degree"=>@degree.id, "start_semester"=>@semester.semester, "start_year"=>@semester.year}
      @uid=1
    end

    it "should create a Student appropriately in the db given the appropriate arguments" do

      Degree.should_receive(:find_by_id).and_return(@degree)
      Semester.should_receive(:find_by_semester_and_year).and_return(@semester)
      Student.create_from_registration(@details, @uid)
    end

    after :all do
      Semester.delete_all
      Student.delete_all
      Degree.delete_all
    end
  end
end
