import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/firebaseAuthMethods.dart';
import 'package:fitness_app/screens/homeScreen.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(16.0, 16.0)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          side: MaterialStateProperty.all(BorderSide(color: Colors.black12)),
          textStyle:
              MaterialStateProperty.all(TextStyle(color: Colors.black54)),
          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
        ),
        onPressed: () {
          FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/google_logo1600.png"),
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
