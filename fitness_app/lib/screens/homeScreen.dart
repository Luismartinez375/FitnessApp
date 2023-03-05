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

// var workoutList = [
//   Workout("Barbell Squat", 3, 10, 225),
//   Workout("Leg Extension", 3, 12, 140),
//   Workout("RDL (Romanian Deadlift)", 3, 8, 135),
//   Workout("Hack Squat", 3, 10, 215),
// ];

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

  List<Widget> dynamicList = [];
  Icon floatingIcon = new Icon(Icons.add);
  int num = 0;
  void newCard() {
    dynamicList.add(new Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter your workout'),
              style: TextStyle(fontSize: 15, height: 2.0, color: Colors.black)),
        )));
  }

  final CollectionReference _workouts =
      FirebaseFirestore.instance.collection('workouts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      AppBar(
        title: Text(
          "Schedule",
          textAlign: TextAlign.center,
        ),
      ),

      Text(
        ' Days                     Day Type               ',
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      // Text(
      //   'Day Type',
      //   textAlign: TextAlign.center,
      // ),
      // Text(
      //   'Workout',
      //   textAlign: TextAlign.end,
      // ),
      WorkoutCards(),
      Text(
        '  Workouts',
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      Exercises(),

      Row(mainAxisSize: MainAxisSize.min, children: [
        const Text(
          ' Sets   ',
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        )
      ]),
      Sets(),
      Text(
        '  Reps',
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      Reps(),
      Text(
        '  Weight (Pounds)',
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
      Weights(),

      // WorkoutCard(
      //     exerciseName: 'exerciseName',
      //     muscleGroup: 'muscleGroup',
      //     description: 'description'),
      // Expanded(child: ListView.builder(itemBuilder: (_, index){
      //   return WorkoutCard(exerciseName: exerciseName, muscleGroup: muscleGroup, description: description);
      // }))
      Expanded(
          child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(onPressed: () {
                num++;
                setState(() {
                  newCard();
                });
                floatingIcon;
              }))),
    ] // Row(children: dynamicList),
            ));
  }
}

//         body: StreamBuilder(
//             stream: _workouts.snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//               if (streamSnapshot.hasData) {
//                 return ListView.builder(
//                     itemCount: streamSnapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       final DocumentSnapshot documentSnapshot =
//                           streamSnapshot.data!.docs[index];
//                       return Card(
//                           margin: const EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text(documentSnapshot['workouts']),
//                             subtitle: Text(documentSnapshot['reps'].toString()),
//                           ),
//                           );
//                     },
//                     );
//               }
//               ;
//             }));
//   }
// }
