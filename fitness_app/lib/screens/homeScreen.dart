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
final db = Database();

// var workoutPlan = WorkoutPlan("Monday", "Leg-Push", workoutList);

bool ispressed = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get description => null;

  final CollectionReference _workouts =
      FirebaseFirestore.instance.collection('workouts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "HomeScreen",
          ),
        ),
        body: ListView(children: [
          SizedBox(
              child: ListTile(
            title: const Text('Todays Workouts'),
            subtitle: const Text('Pull'),
          )),
          const Text('Lat Pulldown'),
          SizedBox(
              child: ListTile(
            title: const Text('Tomorrows Workouts'),
            subtitle: const Text('Push'),
          )),
          SizedBox(
              child: ListTile(
            title: const Text('Yesterdays Workouts'),
            subtitle: const Text('Leg'),
          )),
          Container(
            child: Text(
              'Add Workout Plan',
              textAlign: TextAlign.right,
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyWidget()));
                    });
                  }))
        ]));
  }
}
