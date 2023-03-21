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

                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...exercises.map((exercise) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle onTap event if necessary
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade200, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    leading: SizedBox(
                                      width: 85,
                                      height: 50,
                                      child: Image.asset(exercise['imageUrl'],
                                          fit: BoxFit.cover),
                                    ),
                                    title: Text('${exercise['name']}', style: TextStyle(fontWeight: FontWeight.bold),),
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
                        child:
                            Text('Create Workout', textAlign: TextAlign.right),
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
      .collection('workoutplans')
      .orderBy('timestamp', descending: true)
      .snapshots();
}
