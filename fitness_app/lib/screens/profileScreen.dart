import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;


@override
Widget build(BuildContext context) {
   
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
    ),
    body: FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        int age = calculateAge(userData['dateOfBirth'].toDate());
        String height = "${userData['heightft']}'${userData['heightinch']}\"ft";

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${userData['Name']} ${userData['lastName']}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      
                      child: Column(
                        children: [
                          smallCard('Age', '$age'),
                          smallCard('Gender', '${userData['gender']}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          smallCard('Height', height),
                          smallCard('Weight', '${userData['weight']}'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                    child: Text('Edit'),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smallCard('Neck', '${userData['neck']}'),
                          smallCard('Shoulder', '${userData['shoulder']}'),
                          smallCard('Chest', '${userData['chest']}'),
                          smallCard('Waist', '${userData['waist']}'),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          smallCard('Hip', '${userData['hip']}'),
                          smallCard('Bicep', '${userData['bicep']}'),
                          smallCard('Thigh', '${userData['thigh']}'),
                          smallCard('BMI', '${userData['BMI']}'),
                          smallCard('Body Fat', '${userData['bodyFat']}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/human_body.png',
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

int calculateAge(DateTime dateOfBirth) {
  final currentDate = DateTime.now();
  int age = currentDate.year - dateOfBirth.year;
  int month1 = currentDate.month;
  int month2 = dateOfBirth.month;

  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    final day1 = currentDate.day;
    final day2 = dateOfBirth.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}


Widget smallCard(String title, String value) {
  return Card(
    margin: EdgeInsets.all(4),
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}
}