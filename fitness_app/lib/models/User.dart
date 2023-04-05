import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';

class curUser {
  String? name;
  String? email;
  String? lastName;
  String? userName;
  DateTime? dateOfBirth;
  String? gender;
  int heightft = 0;
  int heightinch = 0;
  int weight = 0;
  int neck = 0;
  int hip = 0;
  int shoulder = 0;
  int chest = 0;
  int bicep = 0;
  int thigh = 0;
  int waist = 0;
  double bmi = 0.0;
  double body_fat = 0.0;
  List<String>? workoutIDs;

  curUser({
    this.name,
    this.email,
    this.lastName,
    this.userName,
    this.dateOfBirth,
    this.gender,
        this.workoutIDs,
  }) {
    if (weight != null && heightft != null && heightinch != null) {
      int heightInInches = (heightft! * 12) + heightinch!;
      double heightInMeters = heightInInches * 0.0254;
      bmi = weight! / (heightInMeters * heightInMeters);

      // Calculate body fat percentage using the U.S. Navy method as an example
      if (gender == 'male') {
        body_fat = 86.010 * (Math.log(waist - neck) / Math.log(10)) - 70.041 * (Math.log(heightInInches) / Math.log(10)) + 36.76;
      } else if (gender == 'female') {
        body_fat = 163.205 * (Math.log(waist + hip - neck) / Math.log(10)) - 97.684 * (Math.log(heightInInches) / Math.log(10)) - 78.387;
      }
    }
  }

  factory curUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return curUser(
      name: data?['name'],
      email: data?['email'],
      lastName: data?['lastName'],
      userName: data?['userName'],
      dateOfBirth: (data?['dateOfBirth'] as Timestamp?)?.toDate(),
      gender: data?['gender'],
      
      workoutIDs: data?['workoutIDs'] is Iterable ? List.from(data?['workoutIDs']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "Name": name,
      if (email != null) "email": email,
      if (lastName != null) "lastName": lastName,
      if (userName != null) "userName": userName,
      if (dateOfBirth != null) "dateOfBirth": Timestamp.fromDate(dateOfBirth!),
      if (gender != null) "gender": gender,
      "heightft": heightft,
      "heightinch": heightinch,
      "weight": weight,
      "neck": neck,
      "hip": hip,
      "shoulder": shoulder,
      "chest": chest,
      "bicep": bicep,
      "thigh": thigh,
      "waist": waist,
      "bmi": bmi,
      "body_fat": body_fat,
      if (workoutIDs != null) "workoutIDs": workoutIDs,
    };
  }
}