import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/snackBar.dart';
import '../models/User.dart';
import '../models/workout.dart';
import '../models/workoutPlan.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  final db = FirebaseFirestore.instance;

  User? firebaseUser() {
    return _auth.currentUser;
  }

  //Email sign up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String userName,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(
        context,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    final cUser = curUser(
        name: name,
        email: email,
        lastName: lastName,
        userName: userName,
        workoutIDs: []);
    final docRef = db
        .collection('users')
        .withConverter(
          fromFirestore: curUser.fromFirestore,
          toFirestore: (curUser user, options) => user.toFirestore(),
        )
        .doc(_auth.currentUser?.uid.toString());
    await docRef.set(cUser);
  }

  //Email login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Google sign in
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Creat a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          //if user has credentials and is valid user navigate to home page
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          if (userCredential.additionalUserInfo!.isNewUser) {
            ///if user signs in through google
            ///and is new user
            ///functions to do stuff witht that new user such as add info to firestore database
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //Email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}

class Database {
  String? workoutID;
  final db = FirebaseFirestore.instance;
  Future<void> addWorkoutPlan({
    required String split,
    required String day,
  }) async {
    final curPlan = WorkoutPlan(
      split: split,
      day: day,
    );
    final docRef = db
        .collection('workouts')
        .withConverter(
          fromFirestore: WorkoutPlan.fromFirestore,
          toFirestore: (WorkoutPlan workoutplan, options) =>
              workoutplan.toFirestore(),
        )
        .doc();
    await docRef.set(curPlan);
    workoutID = docRef.id.toString();
  }

  Future<void> addWorkout({
    required String workoutID,
    required String name,
    required double sets,
    required double reps,
    required double weight,
  }) async {
    final curWorkout = Workout(
      name: name,
      sets: sets,
      reps: reps,
      weight: weight,
    );
    final docRef = db
        .collection('workouts')
        .doc(workoutID)
        .collection('exercise')
        .withConverter(
            fromFirestore: Workout.fromFirestore,
            toFirestore: (Workout exercise, options) => exercise.toFirestore())
        .doc(curWorkout.name);

    await docRef.set(curWorkout);
  }
}
