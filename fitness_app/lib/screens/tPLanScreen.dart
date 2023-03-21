import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:fitness_app/screens/tWorkoutScreen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebaseAuthMethods.dart';
import '../widgets/snackBar.dart';

final user = FirebaseAuthMethods(FirebaseAuth.instance).firebaseUser();
final db = Database();

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController splitController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void makePlan() async {
    db.addWorkoutPlan(
        split: splitController.text,
        day: dayController.text,
        workoutIDs: [user?.uid],
        workoutDate: DateTime.parse("${dateController.text} 00:00:00"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Add Workout Plan'),
          const SizedBox(
            height: 25,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: splitController,
              hintText: 'Enter Split',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: dayController,
              hintText: 'Enter day',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: dateController,
              hintText: 'Enter date of workout (yyyy-mm-dd)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (splitController.text != "" &&
                  dayController.text != "" &&
                  dateController != "") {
                makePlan();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addWorkout()));
              } else {
                showSnackBar(context, 'please enter fields');
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "submit",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "back",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
