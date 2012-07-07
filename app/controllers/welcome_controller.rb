class WelcomeController < ActionController::Base
  protect_from_forgery

  def index
  end

  def about
    redirect_to :root
  end

  def contact
    redirect_to :root
  end

  def submit
    #have to put stuff for submission of the form
    redirect_to :root
  end

  def login
    redirect_to :root
  end
end

