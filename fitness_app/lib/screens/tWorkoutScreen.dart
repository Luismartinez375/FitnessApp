import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:fitness_app/widgets/listItem.dart';
import 'package:flutter/material.dart';
import '../auth/firebaseAuthMethods.dart';
import '../widgets/custom_textfield.dart';

class addWorkout extends StatefulWidget {
  State<addWorkout> createState() => _addWorkoutState();
}

class _addWorkoutState extends State<addWorkout> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  void addWorkout(id) async {
    Database().addWorkout(
        workoutID: id,
        name: nameController.text,
        sets: setsController.text,
        reps: repsController.text,
        weight: weightController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              final data = snapshot.data!;
              final curID = data.get('curWorkout');
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const Text('Add exercise'),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: nameController,
                      hintText: 'Enter name of exercise',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: setsController,
                      hintText: 'Enter amount of sets',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: repsController,
                      hintText: 'Enter amount of reps',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: weightController,
                      hintText: 'Enter weight',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (nameController.text != "" &&
                            setsController.text != "" &&
                            repsController.text != "" &&
                            weightController.text != "") {
                          addWorkout(curID);
                        }
                      },
                      child: const Text(
                        'submit',
                        style: TextStyle(color: Colors.white),
                      )),

                  // const SizedBox(
                  //     height: 20,
                  //     child: FloatingActionButton(
                  //         child: Icon(Icons.add),
                  //         onPressed: () {
                  //           setState(() {
                  //             Navigator.push(context,
                  //                 MaterialPageRoute(builder: (context) => HomePage()));
                  //           });
                  //         }))

                  // ElevatedButton(onPressed: () {
                  //   setState(() {
                  //     Navigator.push(
                  //         context, MaterialPageRoute(builder: (context) => HomePage()));
                  //   });
                  // })
                ],
              );
            }));
  }
}
