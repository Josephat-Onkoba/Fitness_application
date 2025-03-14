class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:alert] = "Email address not found"
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      # Change these lines:
      # session[:user_id] = @user.id
      # @user.update_attribute(:reset_digest, nil)
      # flash[:notice] = "Password has been reset."
      # redirect_to root_url
      
      # To these lines:
      @user.update_attribute(:reset_digest, nil)
      flash[:notice] = "Password has been reset successfully! Please log in with your new password."
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  # Before filters
  
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  # Confirms a valid user
  def valid_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  # Checks expiration of reset token
  def check_expiration
    if @user.password_reset_expired?
      flash[:alert] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end