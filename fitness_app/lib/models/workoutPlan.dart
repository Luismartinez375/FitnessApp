import 'workout.dart';

class WorkoutPlan {
  String day;
  String type;
  List<Workout> workouts;

  WorkoutPlan(this.day, this.type, this.workouts);
  String getDay() {
    return day;
  }

  String getType() {
    return type;
  }

  List getPlan() {
    return workouts;
  }
}
