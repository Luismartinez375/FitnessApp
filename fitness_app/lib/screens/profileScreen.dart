import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          int age = calculateAge(userData['dateOfBirth'].toDate());

          String height =
              "${userData['heightft']}'${userData['heightinch']}\"ft";

          double weightInPounds = userData['weight'] is int
              ? userData['weight'].toDouble()
              : userData['weight'];
          int heightFt = userData['heightft'];
          int heightInch = userData['heightinch'];

          double totalHeightInInches =
              (heightFt * 12).toDouble() + heightInch.toDouble();

          double bodyFat = calculateBodyFat(
            waist: userData['waist'] is int
                ? userData['waist'].toDouble()
                : userData['waist'],
            hip: userData['hip'] is int
                ? userData['hip'].toDouble()
                : userData['hip'],
            neck: userData['neck'] is int
                ? userData['neck'].toDouble()
                : userData['neck'],
            height: totalHeightInInches,
            gender: userData['gender'],
          );

          // Calculate BMI using the provided formula
          double bmi = calculateBMI(weightInPounds, totalHeightInInches);

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
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            smallCard('Age', '$age'),
                            smallCard('Height', height,
                                onTap: () => _updateHeight(
                                    context,
                                    userData['heightft'],
                                    userData['heightinch'])),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            smallCard('Gender', '${userData['gender']}'),
                            
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Weight', userData['weight']),
                              child:
                                  smallCard('Weight', '${userData['weight']}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _editProfile(context, userData);
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
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Neck', userData['neck']),
                              child: smallCard('Neck', '${userData['neck']}'),
                            ),
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Shoulder', userData['shoulder']),
                              child: smallCard(
                                  'Shoulder', '${userData['shoulder']}'),
                            ),
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Chest', userData['chest']),
                              child: smallCard('Chest', '${userData['chest']}'),
                            ),
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Waist', userData['waist']),
                              child: smallCard('Waist', '${userData['waist']}'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () =>
                                  _updateValue(context, 'Hip', userData['hip']),
                              child: smallCard('Hip', '${userData['hip']}'),
                            ),
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Bicep', userData['bicep']),
                              child: smallCard('Bicep', '${userData['bicep']}'),
                            ),
                            InkWell(
                              onTap: () => _updateValue(
                                  context, 'Thigh', userData['thigh']),
                              child: smallCard('Thigh', '${userData['thigh']}'),
                            ),
                            smallCard('BMI', bmi.toStringAsFixed(1)),
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

  Future<void> _updateHeight(
      BuildContext context, int heightft, int heightinch) async {
    TextEditingController feetController =
        TextEditingController(text: heightft.toString());
    TextEditingController inchesController =
        TextEditingController(text: heightinch.toString());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Height'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: feetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Feet'),
              ),
              TextField(
                controller: inchesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Inches'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'heightft': int.parse(feetController.text),
                  'heightinch': int.parse(inchesController.text),
                });

                // Recalculate and update BMI and Body Fat
                DocumentSnapshot updatedUserData = await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .get();
                Map<String, dynamic> data =
                    updatedUserData.data() as Map<String, dynamic>;
                double heightInInches = (data['heightft'] * 12).toDouble() +
                    data['heightinch'].toDouble();
                double bmi = calculateBMI(data['weight'], heightInInches);
                double bodyFat = calculateBodyFat(
                  waist: data['waist'].toDouble(),
                  hip: data['hip'].toDouble(),
                  neck: data['neck'].toDouble(),
                  height: heightInInches,
                  gender: data['gender'],
                );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'bmi': bmi,
                  'bodyFat': bodyFat,
                });

                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  double calculateBMI(double weightInPounds, double heightInInches) {
    return (weightInPounds / (heightInInches * heightInInches)) * 703;
  }

  double calculateBodyFat({
    required double waist,
    required double hip,
    required double neck,
    required double height,
    required String gender,
  }) {
    final log10 = (num x) => log(x) / ln10;
    double result;

    if (gender == 'Male') {
      result = 86.010 * log10(waist - neck) - 70.041 * log10(height) + 36.76;
    } else {
      result =
          163.205 * log10(waist + hip - neck) - 97.684 * log10(height) - 78.387;
    }

    return double.parse(result.toStringAsFixed(2));
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

Future<void> _editProfile(BuildContext context, Map<String, dynamic> userData) async {
  TextEditingController firstNameController =
      TextEditingController(text: userData['Name']);
  TextEditingController lastNameController =
      TextEditingController(text: userData['lastName']);
  TextEditingController dobController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(userData['dateOfBirth'].toDate()));

  String? gender = userData['gender'];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: userData['dateOfBirth'].toDate(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    dobController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female']
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  gender = newValue;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              DateTime dob = DateFormat('yyyy-MM-dd').parse(dobController.text);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .update({
                'Name': firstNameController.text,
                'lastName': lastNameController.text,
                'dateOfBirth': Timestamp.fromDate(dob),
                'gender': gender,
              });

              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
  Future<void> _updateValue(
      BuildContext context, String key, dynamic currentValue) async {
    TextEditingController controller =
        TextEditingController(text: currentValue.toString());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $key'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({key.toLowerCase(): double.parse(controller.text)});

                // Recalculate and update BMI and Body Fat
                DocumentSnapshot updatedUserData = await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .get();
                Map<String, dynamic> data =
                    updatedUserData.data() as Map<String, dynamic>;
                double heightInInches = (data['heightft'] * 12).toDouble() +
                    data['heightinch'].toDouble();
                double bmi = calculateBMI(data['weight'], heightInInches);
                double bodyFat = calculateBodyFat(
                  waist: data['waist'].toDouble(),
                  hip: data['hip'].toDouble(),
                  neck: data['neck'].toDouble(),
                  height: heightInInches,
                  gender: data['gender'],
                );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({
                  'bmi': bmi,
                  'bodyFat': bodyFat,
                });

                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget smallCard(String title, String value, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
