class PlannersController < ApplicationController

  before_filter :require_login_and_registration

  def show
  end

  def index
    if (session[:user_id].nil?)
      redirect_to root_path
    end

    @p_planners = PastPlanner.find_all_semester_groups(current_user)
    @f_planners = FuturePlanner.find_all_semester_groups(current_user)
  end

    # GET /courses and /semesters
  def plan
    @courses = Course.all
    @semesters = Semester.all
    @p_planners = PastPlanner.find_all_semester_groups(current_user)
    @f_planners = FuturePlanner.find_all_semester_groups(current_user)
  end

  def check
    @user = current_user
    @unit_reqs = Planner.find_unit_requirements_fulfilled(current_user)
    @course_reqs = Planner.find_course_requirements_fulfilled(current_user)
  end

  def add
    if(params[:sid].nil? || params[:cid].nil? || params[:pname].nil? || params[:sid] == [""] || params[:cid] == [""] || params[:pname] == [""])
      flash[:notice]="Unable to add to the planner. Please check the parameters."
      redirect_to planners_index_path
    else

      isPlanner = true

      if(params[:pname] == ['Record'])
        logger.debug("REACHED PLANNERS/ADD ACTION, params is #{params}")
        res=PastPlanner.create(:user_id => current_user.id, :course_id=>(params[:cid].first.to_i), :semester_id => params[:sid].first.to_i, :planner_name=>params[:pname])
        isPlanner = false
      else
        res=FuturePlanner.create(:user_id => current_user.id, :course_id=>(params[:cid].first.to_i), :semester_id => params[:sid].first.to_i, :planner_name=>params[:pname])
      end

      if (res.valid?)
        if (isPlanner)
          flash[:notice]="Added to the planner successfully!"
        else
          flash[:notice]="Added to the record successfully!"
        end
      else
        flash[:notice]="Unable to add to the planner. Please check the parameters."
      end
      redirect_to(planners_plan_path(:pname=>params[:pname]))

    end
  end

  # You should only be able to reach here from the "Manage Planner" View, which
  # is the planners_plan_path, so once the planner is destroyed, you should
  # return back to where you came from
  def destroy
    @planner = Planner.find_by_id(params[:id])
    @planner.destroy
    flash[:notice] = "#{@planner.course.abb} has been deleted"
    redirect_to planners_plan_path(:pname=>params[:pname])
  end
end
