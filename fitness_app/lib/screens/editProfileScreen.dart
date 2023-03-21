import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import '../auth/firebaseAuthMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final user = FirebaseAuthMethods(FirebaseAuth.instance).firebaseUser();
final db = FirebaseFirestore.instance;
Map? data;
final docRef = db.collection('users').doc(user?.uid);
final userDocs = docRef.get().then((DocumentSnapshot doc) {
  final userData = doc.data() as Map<String, dynamic>;
  data = userData;
  // ...
});

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      AppBar(
        title: Text(
          'GymRat',
          style: TextStyle(fontFamily: 'Stronger', fontSize: 60.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      Text(" "),

      // StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('workouts')
      //       .where('workoutIDs', arrayContains: user?.uid)
      //       .snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     var docs = snapshot.data?.docs;
      //     return Column(
      //         children:
      //             docs!.map((doc) => Text(doc.data().toString())).toList());
      //   },
      // ),
      // StreamBuilder(
      //   stream:
      //       FirebaseFirestore.instance.collectionGroup('exercise').snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     var docs = snapshot.data?.docs;
      //     return Column(
      //         children: docs!
      //             .map((doc) => Text(
      //                   doc.data().toString(),
      //                   style: TextStyle(
      //                       fontSize: 20,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.red),
      //                 ))
      //             .toList());
      //   },
      // ),
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
          final userName = data.get('userName');
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Profile Information',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Divider(),
                Text(
                  'Username: $userName',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Divider(),
                Text(
                  'First Name: $name',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Divider(),
                Text(
                  'Last Name: $lastName',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Divider(),
                Text(
                  'Email: $email',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Divider(),
                Text(
                  'Workouts: $workoutids',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.black.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.black.withOpacity(0.12);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () {},
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Update Profile')))
              ]);
        },
      ),
    ]));
  }
}
