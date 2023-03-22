import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlan {
  String? day;
  String? split;
  List<String?>? workoutIDs;
  // DateTime? workoutDate;

  WorkoutPlan({
    this.day,
    this.split,
    this.workoutIDs,
  });

  factory WorkoutPlan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return WorkoutPlan(
      day: data?['day'],
      split: data?['Split'],
      workoutIDs: data?['workoutIDs'] is Iterable
          ? List.from(data?['workoutIDs'])
          : null,
      // workoutDate: data?['workoutDate']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (day != null) "day": day,
      if (split != null) "split": split,
      if (workoutIDs != null) "workoutIDs": workoutIDs,
      // if (workoutDate != null) "workoutDate": workoutDate,
    };
  }
}
