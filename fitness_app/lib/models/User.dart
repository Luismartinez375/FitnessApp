import 'package:cloud_firestore/cloud_firestore.dart';

class curUser {
  String? name;
  String? email;
  String? lastName;
  String? userName;
  List<String>? workoutIDs;
  curUser(
      {this.name, this.email, this.lastName, this.userName, this.workoutIDs});

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
      workoutIDs: data?['workoutIDs'] is Iterable
          ? List.from(data?['workoutIDs'])
          : null,
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "Name": name,
      if (email != null) "email": email,
      if (lastName != null) "lastName": lastName,
      if (userName != null) "userName": userName,
      if (workoutIDs != null) "workout-IDs": workoutIDs
    };
  }
}
