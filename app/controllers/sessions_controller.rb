class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(username: params[:username]) || User.find_by(email: params[:username])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Logged in successfully!"
    else
      flash.now[:error] = "Invalid username/email or password"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end