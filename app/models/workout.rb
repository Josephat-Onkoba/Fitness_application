class Workout < ApplicationRecord
  belongs_to :user
  
  validates :workout_type, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :calories_burned, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :date, presence: true
  
  # Workout types for a gym
  WORKOUT_TYPES = [
    'Strength Training', 'Cardio', 'HIIT', 'CrossFit', 'Yoga', 
    'Pilates', 'Spinning', 'Circuit Training', 'Functional Training',
    'Weight Lifting', 'Bodybuilding', 'TRX', 'Boxing', 'Kickboxing',
    'Zumba', 'Group Fitness', 'Personal Training'
  ]
  
  before_save :calculate_calories_burned, if: -> { calories_burned.nil? }
  
  private
  
  def calculate_calories_burned
    # Simple estimation based on workout type and duration
    calories_per_minute = case workout_type.downcase
                          when 'cardio', 'spinning', 'hiit', 'zumba'
                            10
                          when 'strength training', 'weight lifting', 'bodybuilding', 'circuit training'
                            7
                          when 'yoga', 'pilates'
                            5
                          when 'boxing', 'kickboxing', 'crossfit'
                            12
                          when 'functional training', 'trx'
                            8
                          when 'group fitness', 'personal training'
                            9
                          else
                            6
                          end
    
    self.calories_burned = calories_per_minute * duration
  end
end