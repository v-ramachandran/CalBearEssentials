class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :logged_in?
  helper_method :require_login
  helper_method :require_registration
  helper_method :try_register_user

  def index

  end

  private


  def require_login_and_registration
    return if require_login
    require_registration
  end

  def require_login
    unless logged_in?
      flash[:error] = "Please log in before continuing."
      redirect_to root_path
    end
  end

  def try_register_user
    if @user.nil?
      @user = User.find_by_uid(session[:user_id])
    end
  end

  def require_registration
    try_register_user
    if @user.nil?
      # Storing the user's facebook in the flash, so that upon redirection we
      # can prepopulate some of the registration form for the user. Not using
      # session here because session needs to be small, and don't know if we
      # want the facebook info to persist in the session hash.
      # However, this means that if a user got to new_user_path in any other
      # means, they would not have the autocomplete functionality.
      return redirect_to new_user_path
    end
  end

  # Add the user info to the flash. Pass in the details from facebook's
  # auth[info] to make this work
  def add_user_info_to_flash (details)
    flash[:user_fb_info] = {"first_name" => details["first_name"],
      "last_name" => details["last_name"],
      "email" => details["email"]
    }
  end

  def logged_in?
    not session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find_by_uid(session[:user_id]) if session[:user_id]
  end
end

