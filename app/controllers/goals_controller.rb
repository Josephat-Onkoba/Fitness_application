class GoalsController < ApplicationController
  before_action :require_login
  before_action :set_goal, only: [:show, :edit, :update, :destroy]
  
  def index
    @goals = current_user.goals.order(target_date: :asc)
  end
  
  def show
  end
  
  def new
    @goal = Goal.new(target_date: Date.today + 30.days)
    @goal_types = Goal::GOAL_TYPES
  end
  
  def create
    @goal = current_user.goals.new(goal_params)
    @goal.initial_value = @goal.current_value
    
    if @goal.save
      redirect_to goal_path(@goal), notice: "Fitness goal created successfully!"
    else
      @goal_types = Goal::GOAL_TYPES
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @goal_types = Goal::GOAL_TYPES
  end
  
  def update
    if @goal.update(goal_params)
      redirect_to goal_path(@goal), notice: "Goal updated successfully!"
    else
      @goal_types = Goal::GOAL_TYPES
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @goal.destroy
    redirect_to goals_path, notice: "Goal deleted successfully!"
  end
  
  private
  
  def set_goal
    @goal = current_user.goals.find(params[:id])
  end
  
  def goal_params
    params.require(:goal).permit(:title, :goal_type, :target_value, :current_value, 
                              :target_date, :description)
  end
end