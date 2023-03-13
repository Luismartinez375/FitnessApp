import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/tPLanScreen.dart';
import 'package:fitness_app/screens/tWorkoutScreen.dart';
import '../auth/firebaseAuthMethods.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:flutter/material.dart';
import '../models/workoutPlan.dart';
import 'package:fitness_app/widgets/listItem.dart';
import 'package:fitness_app/widgets/workoutcard.dart';

final user = FirebaseAuthMethods(FirebaseAuth.instance).firebaseUser();
final db = FirebaseFirestore.instance;
Map? data;
final docRef = db.collection('users').doc(user?.uid);
final userDocs = docRef.get().then((DocumentSnapshot doc) {
  final userData = doc.data() as Map<String, dynamic>;
  data = userData;
  // ...
});
// var workoutPlan = WorkoutPlan("Monday", "Leg-Push", workoutList);

bool ispressed = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get description => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      AppBar(
        title: const Text(
          "HomeScreen",
        ),
      ),
      Text(" "),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('workouts')
            .where('workoutIDs', arrayContains: user?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var docs = snapshot.data?.docs;
          return Text(docs![0].data().toString());
        },
      ),
      StreamBuilder(
        stream:
            FirebaseFirestore.instance.collectionGroup('exercise').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var docs = snapshot.data?.docs;
          return Text(docs![0].data().toString());
        },
      ),
      // Text(docRef.asStream().toString()),
      Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(onPressed: () {
            setState(() {});
          })),
      Text(user!.displayName.toString())
    ]));
  }
}
