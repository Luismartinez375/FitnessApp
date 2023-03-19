import 'package:fitness_app/screens/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymrat_example/services/firebase_auth_methods.dart';
import 'package:gymrat_example/widgets/custom_text_field.dart';
import 'package:gymrat_example/widgets/google_sign_in_button.dart';
import 'package:gymrat_example/screens/email_password_signup.dart';

import '../auth/firebaseAuthMethods.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/googleSigninButton.dart';

class LogIn extends StatefulWidget {
  static String routName = '/login-email-password';
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() {
    FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.redAccent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 10.0,
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/gymrat.png'),
                    radius: 150.0,
                  ),
                ),

                // Email Input
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Password Input
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white),
                      ),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2.5, 50))),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                // Register Navigation
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(
                    child: const Text('Dont have an account? Register here!',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmailPasswordSignup()));
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
// Google Sign In Button
                GoogleSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
               


