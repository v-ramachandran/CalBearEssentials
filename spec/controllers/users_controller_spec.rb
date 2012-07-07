require 'spec_helper'

describe UsersController do
  before :each do
    @student = FactoryGirl.create(:student)
    request.session = {:user_id => @student.uid}
  end

  describe "GET 'new'" do

    it "should retrieve the appropriate degrees by the order of name" do
      Degree.should_receive(:find).with(:all, :order => "name").and_return([])
      get 'new'
    end

    it "should also retrieve all of the distinct semesters and years" do
      Degree.should_receive(:find).with(:all, :order =>"name").and_return([])
      Semester.should_receive(:select).with("distinct(semester)").and_return([])
      Semester.should_receive(:select).with("distinct(year)").and_return([])
      get 'new'
    end

    it "returns http success" do
      Degree.should_receive(:find).with(:all, :order =>"name").and_return([])
      Semester.should_receive(:select).with("distinct(semester)").and_return([])
      Semester.should_receive(:select).with("distinct(year)").and_return([])
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do

    before :all do
      @params = {"first_name" => "Ben", "last_name" => "Bitdiddle",
        "email" => "ben@berkeley.edu", "controller"=>"users", "action"=>"create"}
    end

    it "should call the appropriate model method for registration" do
      Student.should_receive(:create_from_registration).with(@params, @student.uid).and_return(@student)
      post 'create', {"first_name" => "Ben", "last_name" => "Bitdiddle", "email" => "ben@berkeley.edu"}
    end

    it "should flash appropriately" do
      Student.should_receive(:create_from_registration).with(@params, @student.uid).and_return(@student)
      post 'create', {"first_name" => "Ben", "last_name" => "Bitdiddle",
        "email" => "ben@berkeley.edu"}
      flash[:notice].should =~ /Thanks #{@student.first_name}, you have been successfully registered/

    end
    it "returns http redirect" do
      Student.should_receive(:create_from_registration).with(@params, @student.uid).and_return(@student)
      post 'create', {"first_name" => "Ben", "last_name" => "Bitdiddle",
        "email" => "ben@berkeley.edu"}
      flash[:notice].should =~ /Thanks #{@student.first_name}, you have been successfully registered/
      response.should be_redirect
      response.should redirect_to planners_index_path
    end
  end
end
