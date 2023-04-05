import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/WorkoutPage.dart';
import 'package:fitness_app/screens/dailyWorkout.dart';
import 'package:fitness_app/screens/landingScreen.dart';
import 'package:fitness_app/screens/tPLanScreen.dart';
import 'package:fitness_app/screens/tWorkoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/firebaseAuthMethods.dart';
import 'screens/loginScreen.dart';
import 'package:fitness_app/screens/landingScreen.dart';
import 'screens/registerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/homeScreen.dart';
import 'widgets/notifications_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

// import 'screens/tPLanScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones(); // Initialize the timezones
  await initializeNotifications(); // Initialize the notifications
  scheduleDailyNotification(); // Schedule the daily notification
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthMethods>(
      create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
      child: MaterialApp(
        title: 'FitnessApp',
        theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: '/',
        routes: {
          '/': (context) => LogIn(),
          Landing.routeName: (context) => Landing(),
          EmailPasswordSignup.routeName: (context) =>
              Provider<FirebaseAuthMethods>(
                create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
                child: const EmailPasswordSignup(),
              ),
        },
      ),
    );
  }
}
