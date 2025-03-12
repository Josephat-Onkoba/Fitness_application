class UserMailer < ApplicationMailer
  default from: 'your-app@example.com'
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to GymFitness!')
  end
  
  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset | GymFitness')
  end
end