import 'package:fitness_app/auth/firebaseAuthMethods.dart';
import 'package:fitness_app/screens/WorkoutPage.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:fitness_app/screens/profileScreen.dart';
import 'package:fitness_app/widgets/googleSigninButton.dart';
import 'package:fitness_app/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomePage(),
    WorkoutPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GymRat', style: TextStyle(fontFamily: 'Stronger', fontSize: 60.0),),centerTitle: true, backgroundColor: Colors.black,),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}