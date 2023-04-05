//import 'dart:js_interop';

import 'package:fitness_app/auth/firebaseAuthMethods.dart';
import 'package:fitness_app/screens/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_textfield.dart';
import 'homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'loginScreen.dart';

class EmailPasswordSignup extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = '';

  void signUpUser() async {
    //Check if the username is already registered
  final isUsernameTaken = await context
      .read<FirebaseAuthMethods>()
      .isUsernameTaken(usernameController.text);
        // Check if the email is already registered
  final isEmailRegistered = await context
      .read<FirebaseAuthMethods>()
      .isEmailRegistered(emailController.text);


  if (isUsernameTaken) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username is already taken!')),  //it was working... needs to verify if is working
    );
    return;
  }

  if (isEmailRegistered) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email is already registered!')),  //it was working... needs to verify if is working
    );
    return;
  }

  if (_selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a date of birth.')),  //it was working... needs to verify if is working
    );
    return;
  }

  if (_selectedGender.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a gender.')),  //it was working... needs to verify if is working
    );
    return;
  }

  if (emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter an email.')),
    );
    return;
  }

  if (usernameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a username.')),
    );
    return;
  }

  if (nameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter your name.')),
    );
    return;
  }
  if (lastNameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter your last name.')),
    );
    return;
  }
  if (passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a password.')),
    );
    return;
  }

  // If username is not taken, proceed with the registration
  try {
    await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      lastName: lastNameController.text,
      userName: usernameController.text,
      gender: _selectedGender,
      dateOfBirth: _selectedDate!,
    );
    // Check if the email is verified
    if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
      // Navigate to the landing screen
      Navigator.pushReplacementNamed(context, Landing.routeName );
    } else {
      // Display a message about email verification
      // User created successfully, show the pop-up message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User created successfully'),
          content: Text('Please verify your email address.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, LogIn.routName);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
      
    }
  } catch (e) {
    // Handle the error message according to your needs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Sign Up',
            style: TextStyle(fontFamily: 'Stronger', fontSize: 60.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: nameController,
                    hintText: 'Enter First Name',
                    textCapitalization: TextCapitalization.words, //make first letter be capital
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: lastNameController,
                    hintText: 'Enter Last Name',
                    textCapitalization: TextCapitalization.words, //make first letter be capital
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: usernameController,
                    hintText: 'Enter Username',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                    Text(
                      'Gender',
                      style: new TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: new TextStyle(fontSize: 17.0),
                    ),
                    Radio(
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                    Text(
                      'Female',
                      style: new TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
  children: [
    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
    const Text(
      'Day of Birth: ',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    Expanded(
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: ListTile(
          title: const Text('Select Date'),
          subtitle: Text(
            _selectedDate == null
                ? 'Please select a date'
                : DateFormat.yMMMd().format(_selectedDate!),
          ),
          onTap: () {
            _selectDate(context);
          },
        ),
      ),
    ),
  ],
),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    signUpUser();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(color: Colors.white),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width / 2.5, 50),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
