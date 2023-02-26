import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutPlan {
  String? day;
  String? split;

  WorkoutPlan({this.day, this.split});

  factory WorkoutPlan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return WorkoutPlan(
      day: data?['day'],
      split: data?['Split'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (day != null) "day": day,
      if (split != null) "split": split,
    };
  }
}
