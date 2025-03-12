class Goal < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :target_value, presence: true, numericality: { greater_than: 0 }
  validates :current_value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :goal_type, presence: true
  validates :target_date, presence: true
  
  # Goal types for gym fitness
  GOAL_TYPES = [
    'Weight Loss', 'Weight Gain', 'Muscle Building', 
    'Strength Improvement', 'Endurance', 'Flexibility',
    'Body Fat Percentage', 'Bench Press PR', 'Squat PR',
    'Deadlift PR', 'Workout Frequency', 'Cardio Capacity'
  ]
  
  def progress_percentage
    return 0 if current_value.nil? || target_value.nil?
    
    case goal_type.downcase
    when 'weight loss', 'body fat percentage'
      # For these goals, progress increases as current value decreases
      start_value = initial_value || target_value
      progress = [(start_value - current_value) / (start_value - target_value) * 100, 0].max
    else
      # For most goals, progress increases as current value increases toward target
      progress = (current_value / target_value) * 100
    end
    
    # Ensure value is between 0 and 100
    [progress.round, 100].min
  end
  
  def achieved?
    progress_percentage >= 100
  end
  
  def status
    if achieved?
      'Achieved'
    elsif target_date < Date.today
      'Overdue'
    else
      'In Progress'
    end
  end
end