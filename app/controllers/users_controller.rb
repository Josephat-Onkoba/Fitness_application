class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      # Send welcome email
      UserMailer.welcome_email(@user).deliver_now
      
      flash[:notice] = "Account created successfully! Please log in with your credentials."
      redirect_to login_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update(profile_params)
      redirect_to dashboard_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, 
                                :first_name, :last_name)
  end
  
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :bio, :profile_picture)
  end
  
end