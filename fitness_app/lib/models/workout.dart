import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  String? name;
  String? sets;
  String? reps;
  String? weight;
  bool? status = false;
  bool? unit = true;

  Workout(
      {this.name,
      this.sets,
      this.reps,
      this.weight,
      this.status = false,
      this.unit = true});

  factory Workout.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Workout(
      name: data?['name'],
      sets: data?['sets'],
      reps: data?['reps'],
      weight: data?['weight'],
      status: data?['status'],
      unit: data?['unit'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (sets != null) "sets": sets,
      if (reps != null) "reps": reps,
      if (weight != null) "weight": weight,
      if (status != null) "status": status,
      if (unit != null) "unit": unit,
    };
  }
}

// class Days {
//   String day;
//   Days(this.day);
// }
