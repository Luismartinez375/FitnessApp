import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;
import '../widgets/AnimatedProgressBar.dart';
import '../widgets/notifications_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;

  List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> avatarList = [
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
  ];

  Future<void> _showAvatarDialog(
      BuildContext context, Map<String, dynamic> userData) async {
    int? selectedIndex = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select an Avatar'),
        children: avatarList.asMap().entries.map((entry) {
          int index = entry.key;
          String imagePath = entry.value;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(imagePath),
            ),
            title: Text('Avatar ${index + 1}'),
            onTap: () {
              Navigator.of(context).pop(index);
            },
          );
        }).toList(),
      ),
    );

    if (selectedIndex != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'profilePicture': selectedIndex});
    }
  }

// Future<void> _updateProfilePicture(String imagePath) async {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(_auth.currentUser!.uid)
//       .update({'profilePicture': imagePath});
// }

  Map<String, String> _selectedTimes = {
    'Monday': '10:00',
    'Tuesday': '10:00',
    'Wednesday': '10:00',
    'Thursday': '10:00',
    'Friday': '10:00',
    'Saturday': '10:00',
    'Sunday': '10:00',
  };

Map<String, int> _dailyNotificationTimes = {
  'Monday': 0,
  'Tuesday': 0,
  'Wednesday': 0,
  'Thursday': 0,
  'Friday': 0,
  'Saturday': 0,
  'Sunday': 0,
};
Future<void> _selectTime(BuildContext context, String day) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(DateFormat("HH:mm").parse(_selectedTimes[day]!)),
  );
  if (pickedTime != null && pickedTime != _selectedTimes[day]) {
    setState(() {
      _selectedTimes[day] = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
    });

    // Save the selected time to the database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({day: _selectedTimes[day]});
  }
}

 Widget _dayTimeRow(String day) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(day),
      TextButton(
        onPressed: () => _selectTime(context, day),
        child: Text(
          TimeOfDay.fromDateTime(DateFormat("HH:mm").parse(_selectedTimes[day]!))
              .format(context),
        ),
      ),
    ],
  );
}

void _updateSelectedTimes(Map<String, dynamic> userData) {
  if (userData['selectedTimes'] != null) {
    setState(() {
      _selectedTimes = Map<String, String>.from(userData['selectedTimes']);
    });
  }
}


  void _saveTimes() {
    _daysOfWeek.forEach((day) {
      scheduleDailyNotification(
        day: day,
        time: TimeOfDay.fromDateTime(
            DateFormat("HH:mm").parse(_selectedTimes[day]!)),
      );
    });

    // Save the selected times to the database
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'selectedTimes': _selectedTimes});
  }

  

  void scheduleDailyNotification({
    required String day,
    required TimeOfDay time,
  }) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('your_time_zone')); // Set your time zone

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'gym_notification_channel',
      'Gym Notifications',
      channelDescription: 'Reminders to go and train at the gym',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final DateTime now = DateTime.now();

    final DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Find the next occurrence of the selected day of the week
    int difference = dayOfWeekToNumber(day) - now.weekday;
    if (difference < 0) difference += 7;

    final DateTime nextOccurrence =
        scheduledDate.add(Duration(days: difference));

    flutterLocalNotificationsPlugin.zonedSchedule(
      dayOfWeekToNumber(day),
      'Time to train',
      'Don\'t forget to go to the gym and train today!',
      tz.TZDateTime.from(
        nextOccurrence.isBefore(now)
            ? nextOccurrence.add(Duration(days: 7))
            : nextOccurrence,
        tz.local,
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  int dayOfWeekToNumber(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        throw Exception('Invalid day of the week');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userDataStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();

        

   return Scaffold(
    appBar: AppBar(
      title: Text(
        'Profile',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      actions: [
          IconButton(
  icon: Icon(Icons.calendar_today),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: StatefulBuilder( // Add StatefulBuilder here
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._daysOfWeek.map((day) => _dayTimeRow(day)).toList(),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveTimes,
                    child: Text('Save'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  },
),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
         stream: userDataStream,
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


        _selectedTimes = userData['selectedTimes'] != null
    ? Map<String, String>.from(userData['selectedTimes'])
    : {
        'Monday': '10:00',
        'Tuesday': '10:00',
        'Wednesday': '10:00',
        'Thursday': '10:00',
        'Friday': '10:00',
        'Saturday': '10:00',
        'Sunday': '10:00',
      };
        _updateSelectedTimes(userData);
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
          String bodyFatCategory =
              getBodyFatCategory(bodyFat, userData['gender']);

          Color progressBarColor =
              getCategoryColor(bodyFat, userData['gender']);

          // Calculate BMI using the provided formula
          double bmi = calculateBMI(weightInPounds, totalHeightInInches);

          return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _showAvatarDialog(context, userData),
                              child: CircleAvatar(
                                backgroundImage: userData['profilePicture'] !=
                                        null
                                    ? AssetImage(
                                        avatarList[userData['profilePicture']])
                                    : null,
                                backgroundColor: Colors.grey,
                                radius: 50,
                              ),
                            ),
                            Text(
                              '${userData['userName']} ',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${userData['Name']} ${userData['lastName']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              smallCard('Age', '$age'),
                              SizedBox(width: 16),
                              smallCard('Height', height,
                                  onTap: () => _updateHeight(
                                      context,
                                      userData['heightft'],
                                      userData['heightinch'])),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              smallCard('Gender', '${userData['gender']}'),
                              SizedBox(width: 16),
                              InkWell(
                                onTap: () => _updateValue(
                                    context, 'Weight', userData['weight']),
                                child: smallCard(
                                    'Weight', '${userData['weight']}'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _editProfile(context, userData);
                            },
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF263238),
                              onPrimary: Colors.white,
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ...
                  ],
                ),
                SizedBox(height: 24),
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
                      Flexible(
                        child: Column(
                          children: [
                            // Human body image
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                'assets/human_body.png',
                              ),
                            ),
                            // Body fat category text
                            Text(
                              getBodyFatCategory(bodyFat, userData['gender']),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            // Animated progress bar with scale numbers and text
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              child: SizedBox(
                                height:
                                    20.0, // Set a specific height for the progress bar
                                child: Stack(
                                  children: [
                                    AnimatedProgressBar(
                                        value: bodyFat / 35,
                                        color: progressBarColor),
                                    Positioned.fill(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('0'),
                                          Text('14'),
                                          Text('25'),
                                          Text('35+'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  String getBodyFatCategory(double bodyFat, String gender) {
    if (gender == 'Male') {
      if (bodyFat <= 13) return 'Athlete';
      if (bodyFat <= 17) return 'Fitness';
      if (bodyFat <= 24) return 'Average';
      return 'Obese';
    } else {
      if (bodyFat <= 20) return 'Athlete';
      if (bodyFat <= 24) return 'Fitness';
      if (bodyFat <= 31) return 'Average';
      return 'Obese';
    }
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
                //setState(() {});
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

  Future<void> _editProfile(
      BuildContext context, Map<String, dynamic> userData) async {
    TextEditingController firstNameController =
        TextEditingController(text: userData['Name']);
    TextEditingController lastNameController =
        TextEditingController(text: userData['lastName']);
    TextEditingController dobController = TextEditingController(
        text:
            DateFormat('yyyy-MM-dd').format(userData['dateOfBirth'].toDate()));

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
                DateTime dob =
                    DateFormat('yyyy-MM-dd').parse(dobController.text);
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
                //setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Color getCategoryColor(double bodyFat, String gender) {
    //for the progressbar
    if (gender == 'Male') {
      if (bodyFat <= 13) {
        return Colors.blue;
      } else if (bodyFat <= 17) {
        return Colors.green;
      } else if (bodyFat <= 24) {
        return Colors.amber;
      } else {
        return Colors.red;
      }
    } else {
      if (bodyFat <= 20) {
        return Colors.blue;
      } else if (bodyFat <= 24) {
        return Colors.green;
      } else if (bodyFat <= 31) {
        return Colors.amber;
      } else {
        return Colors.red;
      }
    }
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
