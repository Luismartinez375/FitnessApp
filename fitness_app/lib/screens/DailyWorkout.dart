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

   @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentDay,
          style: TextStyle(fontFamily: 'Stronger', fontSize: 24.0),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workoutplan')
            .where('dayOfWeek', isEqualTo: _currentDay)
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Map<String, dynamic> exercises = data['exercises'];
              return ListView.builder(
                shrinkWrap: true,
                itemCount: exercises.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = exercises.keys.elementAt(index);
                  return ExpansionTile(
                    title: Text(key),
                    children: [
                      ListTile(
                        leading: Image.network(exercises[key]['imageUrl']),
                        title: Text(exercises[key]['name']),
                        subtitle: Text(
                            'Sets: ${exercises[key]['sets']} - Reps: ${exercises[key]['reps']}'),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}