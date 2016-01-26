class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      user_wants_to_be_remembered ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def user_wants_to_be_remembered
    params[:session][:remember_me] == "1"
  end
end
