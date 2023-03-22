import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DailyWorkout extends StatefulWidget {
  const DailyWorkout({Key? key}) : super(key: key);

  @override
  _DailyWorkoutState createState() => _DailyWorkoutState();
}

class _DailyWorkoutState extends State<DailyWorkout> {
  String _currentDay = '';

  @override
  void initState() {
    super.initState();
    _currentDay = DateFormat('EEEE').format(DateTime.now());
  }

  Stream<QuerySnapshot> getDailyWorkouts() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workoutplans')
        .where('dayOfWeek', isEqualTo: _currentDay)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Text(
          _currentDay,
          style: TextStyle(fontFamily: 'Stronger', fontSize: 100.0),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getDailyWorkouts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final workouts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (BuildContext context, int index) {
              final exercises = workouts[index]['exercises'] as List<dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercises.map((exercise) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 1),
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
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
