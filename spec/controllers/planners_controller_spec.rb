require 'spec_helper'

def str(val)

  return val.to_s

end

describe PlannersController do
  before :each do
    Student.delete_all
    @s_user = FactoryGirl.create(:student)
    @student = Student.create!(:uid => 13)
    @semester = FactoryGirl.create(:semester)
    @class = FactoryGirl.create(:course)
    @planner_entry = FactoryGirl.create(:planner, :planner_name=>"test")
  end

  describe "able to access a list of Planners for user" do
    render_views
    describe "success cases" do

      it "should call the find_all_semester_groups function for past and future planners" do
        request.session = {:user_id => @student.uid}
        PastPlanner.should_receive(:find_all_semester_groups).with(@student).and_return([[],{}])
        FuturePlanner.should_receive(:find_all_semester_groups).with(@student).and_return([[],{}])
        get :index
      end

      it "should render the Planners List page for the user if the user id is valid, logged in" do
        request.session = {:user_id=>@s_user.uid}
        Student.create!(:uid => @s_user.uid)
        get :index
        request.session[:user_id].should==@s_user.uid
        response.should render_template :action=>'index', :partial => '_planner'
      end
    end

    describe "failure cases" do
      it "should redirect back to login page if no login has ever occurred" do
        request.session={}
        get :index
        response.should_not render_template('index')
        response.should be_redirect
        response.should redirect_to root_path
      end
    end
  end

  describe "user is able to add a new class to a specific planner" do
    describe "the passed parameters" do
      describe "sanity checks" do
        it "should have a user ID referring to the logged in user" do
          request.session={:user_id=>@s_user.uid}
          post :add, {:pname=>nil}
          response.should_not redirect_to root_path
        end

        it "should render to the main Planners page if course id is nonexistant" do
          Student.create!(:uid => '1')
          request.session={:user_id => @s_user.uid}
          post :add, {:sid=>@semester.id, :pname=>nil}
          response.should redirect_to planners_index_path
        end
        it "should redirect to the login if user id is not in the session" do
          request.session={}
          post :add, {:cid=>@class.id, :sid=>@semester.id, :pname=>nil}
          response.should be_redirect
          response.should redirect_to root_path
        end
        it "should render to the main Planners page if semester id is nonexistant" do
          Student.create!(:uid => '1')
          request.session={:user_id=>@s_user.uid}
          post :add, {:cid=>@class.id}
          response.should redirect_to planners_index_path
        end
      end
    end

    describe "the addition of the class calling the model method" do

      before :each do
        request.session={:user_id=>@s_user.uid}
        #Student.create!(:uid => @s_user.uid)
      end

      it "should call the Planner model's create method" do

        Planner.should_receive(:create).with(:user_id => @s_user.id,
                                             :course_id=> @class.id,
                                             :semester_id => @semester.id,
                                             :planner_name=>str(@planner_entry.planner_name)
                                             ).and_return(@planner_entry)

        @planner_entry.should_receive(:valid?).and_return(true)

        post :add, {:cid=> [@class.id], :sid=> [@semester.id], :pname=>@planner_entry.planner_name}
      end

      it "should redirect back to the show page upon success with a success flash" do
        Planner.should_receive(:create).with(:user_id => @s_user.id,
                                             :course_id=> @class.id,
                                             :semester_id => @semester.id,
                                             :planner_name=>str(@planner_entry.planner_name)
                                             ).and_return(@planner_entry)

        @planner_entry.should_receive(:valid?).and_return(true)

        post :add, {:cid=> [@class.id], :sid=> [@semester.id], :pname=>@planner_entry.planner_name}

        flash[:notice].should_not be_nil
        flash[:notice].should =~ /Added to the planner successfully!/

      end

      it "should redirect back to the show page upon failure with a failure flash" do
        Planner.should_receive(:create).with(:user_id => @s_user.id, :course_id=> @class.id, :semester_id => @semester.id, :planner_name=>str(@planner_entry.planner_name)).and_return(@planner_entry)
        @planner_entry.should_receive(:valid?).and_return(false)

        post :add, {:cid=> [@class.id], :sid=> [@semester.id], :pname=>@planner_entry.planner_name}
        flash[:notice].should_not be_nil
        flash[:notice].should =~ /Unable to add to the planner. Please check the parameters./
      end
    end
  end
end
