class WorkoutsController < ApplicationController
  before_action :require_login
  before_action :set_workout, only: [:show, :edit, :update, :destroy]
  
  def index
    @workouts = current_user.workouts.order(date: :desc)
  end
  
  def show
  end
  
  def new
    @workout = Workout.new(date: Date.today)
    @workout_types = Workout::WORKOUT_TYPES
  end
  
  def create
    @workout = current_user.workouts.new(workout_params)
    
    if @workout.save
      update_goals_from_workout(@workout)
      redirect_to workout_path(@workout), notice: "Workout logged successfully!"
    else
      @workout_types = Workout::WORKOUT_TYPES
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @workout_types = Workout::WORKOUT_TYPES
  end
  
  def update
    if @workout.update(workout_params)
      update_goals_from_workout(@workout)
      redirect_to workout_path(@workout), notice: "Workout updated successfully!"
    else
      @workout_types = Workout::WORKOUT_TYPES
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "Workout deleted successfully!"
  end
  
  private
  
  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end
  
  def workout_params
    params.require(:workout).permit(:workout_type, :duration, :calories_burned, 
                                   :date, :notes, :sets, :reps, :weight, 
                                   :equipment_used, :perceived_exertion)
  end
  
  def update_goals_from_workout(workout)
    # Update related goals based on workout data
    # This is a simplified example - a real implementation would be more complex
    
    user = workout.user
    date = workout.date
    
    # Update 'Workout Frequency' goals
    frequency_goals = user.goals.where(goal_type: 'Workout Frequency')
                          .where('target_date >= ?', date)
    
    frequency_goals.each do |goal|
      # Simply increment current value by 1 for each workout
      goal.update(current_value: goal.current_value + 1)
    end
    
    # Update strength-related goals if this is a strength workout
    if ['Strength Training', 'Weight Lifting', 'Bodybuilding'].include?(workout.workout_type) && 
       workout.weight.present?
      
      if workout.notes&.include?('Bench Press')
        bench_goals = user.goals.where(goal_type: 'Bench Press PR')
        bench_goals.each do |goal|
          goal.update(current_value: [goal.current_value, workout.weight].max)
        end
      elsif workout.notes&.include?('Squat') 
        squat_goals = user.goals.where(goal_type: 'Squat PR')
        squat_goals.each do |goal|
          goal.update(current_value: [goal.current_value, workout.weight].max)
        end
      elsif workout.notes&.include?('Deadlift')
        deadlift_goals = user.goals.where(goal_type: 'Deadlift PR')
        deadlift_goals.each do |goal|
          goal.update(current_value: [goal.current_value, workout.weight].max)
        end
      end
    end
    
    # Update cardio-related goals
    if ['Cardio', 'HIIT', 'Spinning', 'Running'].include?(workout.workout_type)
      cardio_goals = user.goals.where(goal_type: 'Cardio Capacity')
      cardio_goals.each do |goal|
        # Simple approach: just increase current value based on duration
        goal.update(current_value: goal.current_value + (workout.duration / 10.0))
      end
    end
  end
end