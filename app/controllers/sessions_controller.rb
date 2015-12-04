class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email])
  	if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remembering(user) : forget(user)
      redirect_back_or user
  	else
  		flash.now[:danger] = "Invalid email/password"
  		render 'new'
  	end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
