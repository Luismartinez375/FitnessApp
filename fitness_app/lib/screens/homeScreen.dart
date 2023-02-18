import 'package:fitness_app/models/workout.dart';
import 'package:flutter/material.dart';
import '../models/workoutPlan.dart';
import 'package:fitness_app/widgets/listItem.dart';
import 'package:fitness_app/widgets/workoutcard.dart';

var workoutList = [
  Workout("Barbell Squat", 3, 10, 225),
  Workout("Leg Extension", 3, 12, 140),
  Workout("RDL", 3, 8, 135),
  Workout("Hack Squat", 3, 10, 215),
];
var daysList = [
  "Monday",
  "Tuesday",
  "Wedensday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
var workoutPlan = WorkoutPlan("Monday", "Leg-Push", workoutList);

bool ispressed = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get description => null;

  List<WorkoutCards> dynamicList = [];
  newCard() {
    dynamicList = [];
    setState() {
      dynamicList.add(new WorkoutCards());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AppBar(
          title: Text("Day           Day Type       Workout"),
        ),

        WorkoutCards(),
        WorkoutCards(),
        // Expanded(child: ListView.builder(itemBuilder: (_, index){
        //   return WorkoutCard(exerciseName: exerciseName, muscleGroup: muscleGroup, description: description);
        // }))
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: new ElevatedButton(
                  onPressed: newCard(),
                  child: new Icon(Icons.add),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
