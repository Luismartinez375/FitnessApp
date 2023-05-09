import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/ExerciseListScreen.dart';

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Workout'),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: getWorkouts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: daysOfWeek.length,
          itemBuilder: (BuildContext context, int index) {
            final day = daysOfWeek[index];

            // Filter workouts for the current day
            final dailyWorkouts = snapshot.data!.docs.where((doc) {
              return doc['dayOfWeek'] == day;
            }).toList();

            return Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  day,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  if (dailyWorkouts.isNotEmpty)
                    ...dailyWorkouts.map((workout) {
                      final exercises = workout['exercises'] as List<dynamic>;
                      final workoutId = workout.id;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...exercises.map((exercise) {
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                              ),
                              secondaryBackground: Container(
                                color: Colors.blue,
                                child: Icon(Icons.edit, color: Colors.white),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                              ),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  deleteExercise(workoutId, exercise);
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  _showUpdateExerciseDialog(
                                      context, workoutId, exercise);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                  leading: SizedBox(
                                    width: 85,
                                    height: 50,
                                    child: Image.asset(exercise['imageUrl'],
                                        fit: BoxFit.cover),
                                  ),
                                  title: Text(
                                    '${exercise['name']}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Sets: ${exercise['sets']}'),
                                      SizedBox(width: 8),
                                      Text('Reps: ${exercise['reps']}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExerciseListScreen(dayOfWeek: day),
                          ),
                        );
                      },
                      child: Text('Create Workout',
                          textAlign: TextAlign.right),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
}
Future<void> deleteExercise(String workoutId, Map<String, dynamic> exercise) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final workoutRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workoutplans')
      .doc(workoutId);

  await workoutRef.update({
    'exercises': FieldValue.arrayRemove([exercise])
  });

  // Update the leaderboard collection
  await _decrementLeaderboard(exercise['category'], exercise['name']);

}

Future<void> _decrementLeaderboard(String category, String exerciseName) async {
  // Get the reference to the leaderboard collection
  final leaderboardRef = FirebaseFirestore.instance.collection('leaderboard');

  // Get the document corresponding to the exercise category
  final categoryDoc = await leaderboardRef.doc(category).get();

  if (categoryDoc.exists) {
    // If the document exists, decrement the exercise count by 1
    await leaderboardRef.doc(category).update({
      exerciseName: FieldValue.increment(-1),
    });
  }
  // If the document doesn't exist, do nothing as the count should not go below 0
}

Future<void> _showUpdateExerciseDialog(BuildContext context, String workoutId, Map<String, dynamic> exercise) async {
  int sets = exercise['sets'];
  int reps = exercise['reps'];

  final setsController = TextEditingController(text: '$sets');
  final repsController = TextEditingController(text: '$reps');

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Update Exercise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sets:'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          if (sets > 1) {
                            sets--;
                            setsController.text = '$sets';
                          }
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 2,
                        controller: setsController,
                        onChanged: (newValue) {
                          setState(() {
                            sets = int.tryParse(newValue) ?? 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.green[600],
                      ),
                      onPressed: () {
                        setState(() {
                          sets++;
                          setsController.text = '$sets';
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reps:'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          if (reps > 1) {
                            reps--;
                            repsController.text = '$reps';
                          }
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 2,
                        controller: repsController,
                        onChanged: (newValue) {
                          setState(() {
                            reps = int.tryParse(newValue) ?? 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.green[600],
                      ),
                      onPressed: () {
                        setState(() {
                          reps++;
                          repsController.text = '$reps';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () async {
                  await updateExercise(workoutId, exercise, sets, reps);
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
            ],
          );
        },
      );
    },
  );
}
Future<void> updateExercise(String workoutId, Map<String, dynamic> exercise, int sets, int reps) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final workoutRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workoutplans')
      .doc(workoutId);

  final updatedExercise = Map<String, dynamic>.from(exercise);
  updatedExercise['sets'] = sets;
  updatedExercise['reps'] = reps;

  await workoutRef.update({
    'exercises': FieldValue.arrayRemove([exercise])
  });
  await workoutRef.update({
    'exercises': FieldValue.arrayUnion([updatedExercise])
  });
}


Stream<QuerySnapshot> getWorkouts() {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workoutplans')
      .orderBy('timestamp', descending: true)
      .snapshots();
}