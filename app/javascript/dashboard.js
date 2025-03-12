// dashboard.js
document.addEventListener('turbo:load', function() {
    // Goal type change handler - adjust fields based on goal type
    const goalTypeSelect = document.getElementById('goal_goal_type');
    if (goalTypeSelect) {
      const targetValueLabel = document.getElementById('target-value-label');
      const currentValueLabel = document.getElementById('current-value-label');
      
      goalTypeSelect.addEventListener('change', function() {
        const goalType = this.value;
        
        // Update labels based on goal type
        if (goalType === 'Weight Loss' || goalType === 'Weight Gain') {
          targetValueLabel.textContent = 'Target Weight (kg)';
          currentValueLabel.textContent = 'Current Weight (kg)';
        } else if (goalType === 'Body Fat Percentage') {
          targetValueLabel.textContent = 'Target Body Fat (%)';
          currentValueLabel.textContent = 'Current Body Fat (%)';
        } else if (goalType === 'Bench Press PR' || goalType === 'Squat PR' || goalType === 'Deadlift PR') {
          targetValueLabel.textContent = 'Target Weight (kg/lbs)';
          currentValueLabel.textContent = 'Current Weight (kg/lbs)';
        } else if (goalType === 'Workout Frequency') {
          targetValueLabel.textContent = 'Target Workouts (per week)';
          currentValueLabel.textContent = 'Current Workouts (completed)';
        } else {
          targetValueLabel.textContent = 'Target Value';
          currentValueLabel.textContent = 'Current Value';
        }
      });
      
      // Trigger change on load to set initial labels
      const event = new Event('change');
      goalTypeSelect.dispatchEvent(event);
    }
    
    // Workout type change handler - show/hide relevant fields
    const workoutTypeSelect = document.getElementById('workout_workout_type');
    if (workoutTypeSelect) {
      workoutTypeSelect.addEventListener('change', function() {
        const workoutType = this.value;
        const strengthFields = document.querySelectorAll('.strength-field');
        
        if (['Strength Training', 'Weight Lifting', 'Bodybuilding'].includes(workoutType)) {
          strengthFields.forEach(field => field.classList.remove('hidden'));
        } else {
          strengthFields.forEach(field => field.classList.add('hidden'));
        }
      });
    }
  });