class SessionsController < ApplicationController

  before_filter :require_login, :only => [:destroy]

  def create
    # Create a session by requesting omniauth to provide facebook details
    auth = request.env["omniauth.auth"]

    # Check if the user exists in the database, if they do then go to their
    # planners page, otherwise go to the Registration page
    session[:user_id]=auth["uid"]
    flash[:user_fb_info] = auth["info"]

    return if require_registration

    flash[:notice] = "Successfully authorized from your Facebook account"
    redirect_to planners_index_path
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Successfully signed out"
    redirect_to root_url
  end

  def failure
    flash[:error] = "Sorry, but you didn't allow access to our app!"
    redirect_to root_url
  end

end
