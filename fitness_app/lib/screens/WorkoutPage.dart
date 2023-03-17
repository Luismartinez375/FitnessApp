import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// // class WorkoutPage extends StatelessWidget {
// //   final List<Map<String, dynamic>> categories = [    {      'name': 'Chest',      'image': 'assets/images/chest-main.jpg',      'subcategories': [        {          'name': 'Bench Press',          'image': 'assets/images/chest/bench_press.jpg',        },        {          'name': 'Cable Cross Over',          'image': 'assets/images/chest/cable_cross_over.jpg',        },      ],
// //     },
// //     {
// //       'name': 'Back',
// //       'image': 'assets/images/back-main.jpg',
// //       'subcategories': [        {          'name': 'Lat Pull-Down',          'image': 'assets/images/back/lat_pull_down.jpg',        },        {          'name': 'Pull-Up',          'image': 'assets/images/back/pull_up.jpg',        },      ],
// //     },
// //   ];

//  import 'package:flutter/material.dart';

// class WorkoutPage extends StatelessWidget {

//   final List<Map<String, dynamic>> categories = [   
//      {      
//       'name': 'Chest','image': 'assets/images/chest_main.jpg', 
//       'subcategories': [
//         {'name': 'Bench Press','image': 'assets/images/chest/bench_press.jpg',},        
//       { 'name': 'Cable Cross Over', 'image': 'assets/images/chest/cable_cross_over.jpg',},      
//       ],
//      },
//      {
//        'name': 'Back','image': 'assets/images/back_main.jpg',
//        'subcategories': 
//        [
//         {'name': 'Lat Pull-Down','image': 'assets/images/back/lat_pull_down.jpg',},
//        {'name': 'Pull-Up', 'image': 'assets/images/back/pull_up.jpg',},
//        ],
//      },
//  ];

//    WorkoutPage({super.key});

//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exercises'),
//       ),
//       body: GridView.builder(
//         padding: EdgeInsets.all(10),
//         itemCount: categories.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubcategoryPage(
//                     category: categories[index],
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: AssetImage(categories[index]['image']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     categories[index]['name'],
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// class SubcategoryPage extends StatefulWidget {
//   final Map<String, dynamic> category;

//   SubcategoryPage({required this.category});

//   @override
//   _SubcategoryPageState createState() => _SubcategoryPageState();
// }

// class _SubcategoryPageState extends State<SubcategoryPage> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> subcategories = widget.category['subcategories'];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category['name']),
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : GridView.builder(
              
//               padding: EdgeInsets.all(10),
//               itemCount: subcategories.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               // TODO: Implement subcategory tap functionality
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: AssetImage(subcategories[index]['image']),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     subcategories[index]['name'],
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final categories = ['Chest', 'Back', 'Bicep', 'Tricep', 'Abs', 'Shoulder', 'Legs'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseListScreen(category: categories[index]),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(categories[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExerciseListScreen extends StatefulWidget {
  final String category;

  ExerciseListScreen({required this.category});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  // Replace these with your actual exercise image URLs
  final exercises = {
    'Chest': ['https://example.com/chest1.jpg', 'https://example.com/chest2.jpg'],
    'Back': ['https://example.com/back1.jpg', 'https://example.com/back2.jpg'],
    // ... other categories ...
  };

  @override
  Widget build(BuildContext context) {
    final exerciseImages = exercises[widget.category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: exerciseImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              _showExerciseDialog(exerciseImages[index]);
            },
            child: Card(
              child: Image.network(exerciseImages[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
  
Future<void> _showExerciseDialog(String imageUrl) async {
    int sets = 1;
    int reps = 1;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select sets and repetitions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sets:'),
                      DropdownButton<int>(
                        value: sets,
                        items: List.generate(10, (index) => index + 1)
                            .map<DropdownMenuItem<int>>(
                              (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            sets = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reps:'),
                      DropdownButton<int>(
                        value: reps,
                        items: List.generate(30, (index) => index + 1)
                            .map<DropdownMenuItem<int>>(
                              (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            reps = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () async {
                    await _saveExercise(imageUrl, sets, reps);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveExercise(String imageUrl, int sets, int reps) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .add({
          'imageUrl': imageUrl,
          'sets': sets,
          'reps': reps,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }
}
