import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebaseAuthMethods.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:flutter/material.dart';
import '../models/workoutPlan.dart';
import 'package:fitness_app/widgets/listItem.dart';

var workoutList = [
  Workout("Barbell Squat", 3, 10, 225),
  Workout("Leg Extension", 3, 12, 140),
  Workout("RDL (Romanian Deadlift)", 3, 8, 135),
  Workout("Hack Squat", 3, 10, 215),
];

final user = FirebaseAuthMethods(FirebaseAuth.instance).firebaseUser();

var workoutPlan = WorkoutPlan("Monday", "Leg-Push", workoutList);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red,
            child: const ListTile(
              leading: Text("day"),
              title: Text("type"),
              trailing: Text("exercise"),
            ),
          ),
          Expanded(child: ListView.builder(itemBuilder: (_, index) {
            return listItem(workoutPlan, index);
          })),
          Text(
            user!.displayName.toString(),
            textScaleFactor: 1.5,
          )
        ],
      ),
    );
  }
}
