class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :goal_type
      t.float :target_value
      t.float :current_value
      t.float :initial_value
      t.date :target_date
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
