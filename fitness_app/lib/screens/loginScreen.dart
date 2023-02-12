import 'package:fitness_app/auth/firebaseAuthMethods.dart';
import 'package:fitness_app/screens/homeScreen.dart';
import 'package:fitness_app/widgets/googleSigninButton.dart';
import 'package:fitness_app/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
        backgroundColor: Colors.redAccent,
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
                      Flexible(
                          flex: 1,
                          child: Image.asset(
                            'assets/gymRat.png',
                            height: 300,
                            fit: BoxFit.cover,
                          ))
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
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.white),
                        ),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 50))),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
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
                  )
                ]),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            GoogleSignInButton()
          ],
        ));
  }
}
