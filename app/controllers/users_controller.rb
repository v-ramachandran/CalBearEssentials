class UsersController < ApplicationController

  before_filter :require_login

  def new
    # Need to pass all possible degrees, semesters, and years
    @degrees = Degree.find(:all, :order=>"name")
    @semesters = Semester.select("distinct(semester)")
    @years = Semester.select("distinct(year)")
  end

  def create
    # TODO: at the moment, creating a user means creating a student, as we have
    # not really though about how to create other kinds of users, e.g. Admins

    unless Student.valid_form?(params)
      flash[:error] = "Please make sure none of the fields are blank and/or that your email-address is valid"
      logger.debug("PARAMETERS ARE #{params}")
      add_user_info_to_flash(params)
      redirect_to new_user_path and return
    end

    @user = Student.create_from_registration(params, session[:user_id])

    flash[:notice] = "Thanks #{@user.first_name}, you have been successfully registered"
    redirect_to planners_index_path
  end

end
