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
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black26))),
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
        ));
  }
}

class Exercises extends StatefulWidget {
  @override
  _Exercises createState() => _Exercises();
}

class _Exercises extends State<Exercises> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        padding: EdgeInsets.all(5),
        child: Row(children: [
          Expanded(
            child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your workout'),
                style:
                    TextStyle(fontSize: 15, height: 2.0, color: Colors.black)),
          ),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.add))
        ]));
  }
}

class Sets extends StatefulWidget {
  @override
  _Sets createState() => _Sets();
}

class _Sets extends State<Sets> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 10,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Sets'),
              ),
            ),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ],
        ));
  }
}

class Reps extends StatefulWidget {
  const Reps({super.key});

  @override
  State<Reps> createState() => _Reps();
}

class _Reps extends State<Reps> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              width: 75,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Reps'),
              ),
            ),
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
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
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Weight'),
              )),
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.add))
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
// Widget listItem(WorkoutPlan plan, int index) {
//   final workouts = plan.exercies;
//   return Container(
//     padding: const EdgeInsets.all(10),
//     child: ListTile(
//       leading: Text(plan.day.toString(), style: const TextStyle(fontSize: 18)),
//       title: Text(
//         plan.split.toString(),
//         style: const TextStyle(fontSize: 18),
//       ),
//       trailing: Text("monday",
//           style: const TextStyle(fontSize: 18, color: Colors.black)),
//     ),
//     decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
//   );
// }
