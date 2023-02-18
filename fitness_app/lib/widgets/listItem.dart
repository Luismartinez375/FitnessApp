import 'package:fitness_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workoutPlan.dart';
import 'package:fitness_app/models/workout.dart';

class WorkoutCards extends StatefulWidget {
  @override
  _WorkoutCards createState() => _WorkoutCards();
}

void newValue(newValue) {}

class _WorkoutCards extends State<WorkoutCards> {
  TextEditingController Split = new TextEditingController();
  TextEditingController Workout = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> wDays = ['M', 'T', 'W', 'TR', 'F', 'SAT', 'SUN'];

    String dropdownValue = wDays.first;
    return Container(
      padding: const EdgeInsets.all(5),
      // ignore: sort_child_properties_last
      child: ListTile(
          minLeadingWidth: 50.0,
          leading: DropdownButton(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: wDays.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList()),
          title: TextField(
            controller: Split,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your split',

              // onChanged: (text) {
              //   print('$text');
              // },
            ),
            textAlign: TextAlign.start,
          ),
          trailing: SizedBox(
            width: 150.0,
            child: TextField(
              controller: Workout,
              style: TextStyle(fontSize: 15, height: 2.0, color: Colors.black),
            ),
          )),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
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