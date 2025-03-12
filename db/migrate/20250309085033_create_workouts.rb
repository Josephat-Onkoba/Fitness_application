class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :workout_type
      t.integer :duration
      t.float :calories_burned
      t.date :date
      t.text :notes
      t.integer :sets
      t.integer :reps
      t.float :weight
      t.string :equipment_used
      t.integer :perceived_exertion

      t.timestamps
    end
  end
end
