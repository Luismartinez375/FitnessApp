import 'package:fitness_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workoutPlan.dart';
import 'package:fitness_app/models/workout.dart';

// class List extends StatefulWidget {
//   @override
//   _ListState createState() => _ListState();
// }

// class _ListState extends State<List> {}

void newValue(newValue) {}
const List<String> wDays = ['M', 'T', 'W', 'TR', 'F', 'SAT', 'SUN'];
String dropdownValue = wDays.first;

Widget listItem(WorkoutPlan plan, int index) {
  final workouts = plan.workouts;
  return Container(
    padding: const EdgeInsets.all(5),
    // ignore: sort_child_properties_last
    child: ListTile(
      leading: DropdownButton(
          items: wDays.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(child: Text(value), value: value);
          }).toList(),
          onChanged: (String? value) {
            // setState
            // (() {
            //   dropdownValue = value!;
            // });
          }),
      title: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your split',
          // onChanged: (text) {
          //   print('$text');
          // },
        ),
        textAlign: TextAlign.start,
      ),
      trailing: Text(workouts[index].name.toString(),
          style: const TextStyle(fontSize: 18, color: Colors.black)),
    ),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black26))),
  );
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