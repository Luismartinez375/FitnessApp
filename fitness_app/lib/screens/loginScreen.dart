import 'package:fitness_app/auth/firebaseAuthMethods.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:fitness_app/widgets/googleSigninButton.dart';
import 'package:fitness_app/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'landingScreen.dart';

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

  void _hideKeyboard(BuildContext context) {
    // This will dismiss the keyboard when tapping outside of the input fields
    FocusScope.of(context).unfocus();
  }

  void _forgotPassword(BuildContext context) async {
    TextEditingController _emailController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Forgot Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Please enter your email address. We will send a password reset link to your email.'),
                SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  isPassword: false,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text.trim());
                    showSnackBar(context, 'Password reset link sent');
                  } catch (e) {
                    showSnackBar(context, e.toString());
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: Text('Send Reset Link'),
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 10.0,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Column(
                          children: [
                            Text(
                              "GYMRAT",
                              style: TextStyle(
                                fontFamily: 'Stronger',
                                fontSize: 120,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Your fitness journey starts here!",
                              style: TextStyle(
                                fontFamily: 'Stronger',
                                fontSize: 35,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        isPassword: true,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        loginUser();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white),
                        ),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 50)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(8.0),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "Register here!",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailPasswordSignup(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1),
                    TextButton(
                      onPressed: () {
                         _forgotPassword(context);
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                )
              ]),
              const SizedBox(
                height: 1,
              ),
             // GoogleSignInButton()
            ],
          )),
    );
  }
}