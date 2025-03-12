class DashboardController < ApplicationController
  before_action :require_login
  
  def index
    @recent_workouts = current_user.workouts.order(date: :desc).limit(5)
    @goals = current_user.goals.where("status != 'Achieved'").order(target_date: :asc)
  end
end