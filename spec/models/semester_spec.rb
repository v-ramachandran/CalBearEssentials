require 'spec_helper'

describe Semester do
  describe "Test getting label" do
    before :all do
      @sem=Semester.create!(:semester => "Fall", :year => 2011)
    end

    it "should return a string that represents the semester based on semester and year attributes" do
      @sem.get_label.should =~ /Fall 2011/
    end
  end



end
