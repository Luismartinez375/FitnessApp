import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/landingScreen.dart';
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
  required String gender,
  required DateTime dateOfBirth,
}) async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  } on FirebaseAuthException catch (e) {
    print(e.message!); // Handle the error message according to your needs
  }
  final cUser = curUser(
    name: name,
    email: email,
    lastName: lastName,
    userName: userName,
    gender: gender,
    dateOfBirth: dateOfBirth,
    workoutIDs: [],
  );
  final docRef = db
      .collection('users')
      .withConverter(
        fromFirestore: curUser.fromFirestore,
        toFirestore: (curUser user, options) => user.toFirestore(),
      )
      .doc(_auth.currentUser?.uid.toString());
  await docRef.set(cUser);
}

  Future<void> logout() async { //logout
  await _auth.signOut();
}

  //Email login
Future<void> loginWithEmail({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    if (!_auth.currentUser!.emailVerified) {
      await sendEmailVerification(context);
    } else {
      // Use Navigator.pushNamedAndRemoveUntil to navigate to the landing page and empty the navigator stack
      Navigator.pushNamedAndRemoveUntil(
        context,
        Landing.routeName,
        (Route<dynamic> route) => false, // This condition will remove all previous routes from the stack
      );
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
              context, MaterialPageRoute(builder: (context) => Landing()));
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


//Verify if username exists
 Future<bool> isUsernameTaken(String username) async { 
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }

  //verify if email exist
 Future<bool> isEmailRegistered(String email) async {
  try {
    // Fetch the signInMethods associated with the provided email
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

    // If the signInMethods list is empty, the email is not registered
    return signInMethods.isNotEmpty;
  } catch (e) {
    if (e is FirebaseAuthException && e.code == 'user-not-found') {
      return false;
    } else {
      throw e;
    }
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
    required List<String?>? workoutIDs,
  }) async {
    final curPlan = WorkoutPlan(
      split: split,
      day: day,
      workoutIDs: workoutIDs,
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
    required String? workoutID,
    required String? name,
    required String? sets,
    required String? reps,
    required String? weight,
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