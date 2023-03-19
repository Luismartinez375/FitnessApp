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

final user = FirebaseAuthMethods(FirebaseAuth.instance).firebaseUser();
final db = FirebaseFirestore.instance;
Map? data;
final docRef = db.collection('users').doc(user?.uid);
final userDocs = docRef.get().then((DocumentSnapshot doc) {
  final userData = doc.data() as Map<String, dynamic>;
  data = userData;
  // ...
});
// var workoutPlan = WorkoutPlan("Monday", "Leg-Push", workoutList);

bool ispressed = true;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get description => null;

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Search'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        AppBar(
          title: const Text(
            "HomeScreen",
          ),
        ),
        Text(" "),

        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('workouts')
              .where('workoutIDs', arrayContains: user?.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var docs = snapshot.data?.docs;
            return Column(
                children:
                    docs!.map((doc) => Text(doc.data().toString())).toList());
          },
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collectionGroup('exercise')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var docs = snapshot.data?.docs;
            return Column(
                children: docs!
                    .map((doc) => Text(
                          doc.data().toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ))
                    .toList());
          },
        ),
        // Text(docRef.asStream().toString()),

        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            final data = snapshot.data!;
            final name = data.get('Name');
            final lastName = data.get('lastName');
            final email = data.get('email');
            final workoutids = data.get('workout-IDs');
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name: $name',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Last Name: $lastName',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Email: $email',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  Text(
                    'Workouts: $workoutids',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ]);
          },
        ),

        Text(
          user!.displayName.toString(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        ),

        // StreamBuilder<QuerySnapshot>(
        //   stream:
        //       FirebaseFirestore.instance.collectionGroup('exercise').snapshots(),
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //     if (!snapshot.hasData) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     var docs = snapshot.data?.docs;
        //     return ListView.builder(
        //       itemCount: docs!.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         Map<String, dynamic>? data =
        //             docs[index].data() as Map<String, dynamic>?;
        //         return Container(
        //           margin: const EdgeInsets.all(10),
        //           padding: const EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //             border: Border.all(color: Colors.grey),
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 data!['name'],
        //                 style: const TextStyle(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               const SizedBox(height: 10),
        //               Text(
        //                 'Reps: ${data['reps']}',
        //                 style: const TextStyle(fontSize: 16),
        //               ),
        //               Text(
        //                 'Sets: ${data['sets']}',
        //                 style: const TextStyle(fontSize: 16),
        //               ),
        //               Text(
        //                 'Weight: ${data['weight']}',
        //                 style: const TextStyle(fontSize: 16),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ),
        //   StreamBuilder<QuerySnapshot>(
        // stream: FirebaseFirestore.instance
        //     .collectionGroup('exercise')
        //     .snapshots(),
        // builder:
        //     (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //   if (snapshot.hasError) {
        //     return Center(
        //       child: Text('Error: ${snapshot.error}'),
        //     );
        //   }

        //   if (!snapshot.hasData) {
        //     return const Center(
        //       child: CircularProgressIndicator(),
        //     );
        //   }

        //   final List<DocumentSnapshot> documents = snapshot.data!.docs;

        //   return ListView.builder(
        //       itemCount: documents.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         final Map<String, dynamic> data =
        //             documents[index].data() as Map<String, dynamic>;

        //         return Card(
        //           child: ListTile(
        //             leading: CircleAvatar(
        //               child: Text(data['id'].toString()),
        //             ),
        //             title: Text(data['name']),
        //             subtitle: Text(data['description']),
        //             trailing: Text(data['duration'].toString() + ' min'),
        //           ),
        //         );
        //       });
        // }),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyWidget()));
                });
              },
              child: Icon(Icons.add),
            )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
