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
  final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

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
                final timestamp = doc['timestamp'] as Timestamp;
                final date = timestamp.toDate();
                return date.weekday == index + 1;
              }).toList();

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (dailyWorkouts.isNotEmpty)
                      ...dailyWorkouts.map((workout) {
                        return ListTile(
                          leading: Image.network(workout['imageUrl']),
                          title: Text('${workout['sets']} sets x ${workout['reps']} reps'),
                        );
                      }).toList()
                    else
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseListScreen(dayOfWeek: day),
                              ),
                            );
                          },
                          child: Text('Create Workout', textAlign: TextAlign.right),
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

Stream<QuerySnapshot> getWorkouts() {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('workouts')
      .orderBy('timestamp', descending: true)
      .snapshots();
}

