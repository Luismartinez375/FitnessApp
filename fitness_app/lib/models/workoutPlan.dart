import 'workout.dart';

class WorkoutPlan {
  String day;
  String split;
  List<Workout> workouts;

  WorkoutPlan(this.day, this.split, this.workouts);
  String getDay() {
    return day;
  }

  String getType() {
    return split;
  }

  List getPlan() {
    return workouts;
  }
}
