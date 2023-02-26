import 'package:fitness_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workoutPlan.dart';
import 'package:fitness_app/models/workout.dart';

class WorkoutCards extends StatefulWidget {
  // final String exerciseName;
  // final String muscleGroup;
  // final String description;

  // WorkoutCards({
  //   required this.exerciseName,
  //   required this.muscleGroup,
  //   required this.description,
  // });
  @override
  _WorkoutCards createState() => _WorkoutCards();
}

void newValue(newValue) {}

class _WorkoutCards extends State<WorkoutCards> {
  TextEditingController Split = new TextEditingController();
  TextEditingController Workout = new TextEditingController();
  String? dropdownValue = "M";
  List<String> wDays = ["M", "T", "W", "TR", "F", "SAT", "SUN"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
      // ignore: sort_child_properties_last

      child: ListTile(
          minLeadingWidth: 50.0,
          leading: DropdownButton(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: wDays.map<DropdownMenuItem<String>>((String items) {
                return DropdownMenuItem<String>(
                  value: items,
                  child: Text(items),
                );
              }).toList()),
          title: TextField(
            controller: Split,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your split',

              // onChanged: (text) {
              //   print('$text');
              // },
            ),
            onChanged: (value) => Split,
            textAlign: TextAlign.start,
          ),
          trailing: SizedBox(
            width: 150.0,
            child: TextField(
              controller: Workout,
              style: TextStyle(fontSize: 15, height: 2.0, color: Colors.black),
            ),
          )),
    );
  }
}

class Reps extends StatefulWidget {
  @override
  _Reps createState() => _Reps();
}

class _Reps extends State<Reps> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Sets'),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            )
          ],
        ));
  }
}

class Weights extends StatefulWidget {
  @override
  _Weights createState() => _Weights();
}

class _Weights extends State<Weights> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
              width: 75,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              )),
          SizedBox(
              width: 75,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              )),
          SizedBox(
              width: 75,
              child: TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
              )),
        ],
      ),
    );
  }
}
// items: const [
//         DropdownMenuItem(
//           child: Text("M"),
//           value: "Monday",
//         ),
//         DropdownMenuItem(
//           child: Text("T"),
//           value: "Tuesday",
//         ),
//         DropdownMenuItem(
//           child: Text("W"),
//           value: "Wednesday",
//         ),
//         DropdownMenuItem(
//           child: Text("TR"),
//           value: "Thursday",
//         ),
//         DropdownMenuItem(
//           child: Text("F"),
//           value: "Friday",
//         ),
//         DropdownMenuItem(
//           child: Text("S"),
//           value: "Saturday",
//         ),
//         DropdownMenuItem(
//           child: Text("S"),
//           value: dropdownValue,
//         )
//       ],