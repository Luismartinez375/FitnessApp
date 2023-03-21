import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseListScreen extends StatefulWidget {
  final String dayOfWeek;

  ExerciseListScreen({required this.dayOfWeek});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final categories = {
    'Chest': 'assets/chest.png',
    'Back': 'assets/back.png',
    'Bicep': 'assets/bicep.png',
    'Tricep': 'assets/tricep.png',
    'Abs': 'assets/abs.png',
    'Shoulder': 'assets/shoulder.png',
    'Legs': 'assets/legs.png',
  };

  String? _selectedCategory;
  int? _selectedExerciseIndex;

  final exercisesByCategory = {
    'Abs': [
      {'imageUrl': 'assets/images/abs/ball_crunch.JPG', 'name': 'Ball Crunch'},
      {'imageUrl': 'assets/images/abs/sit_up.JPG', 'name': 'Sit-up'},
    ],
    'Back': [
      {'imageUrl': 'assets/images/back/barbell_row.JPG', 'name': 'Barbell Row'},
      {
        'imageUrl': 'assets/images/back/incline_dumbbell_row.JPG',
        'name': 'Incline Dumbell Row'
      },
      {
        'imageUrl': 'assets/images/back/incline_reverse_fly.JPG',
        'name': 'Incline Reverse Fly'
      },
      {
        'imageUrl': 'assets/images/back/lat_pull_down.JPG',
        'name': 'Lat Pull Down'
      },
      {'imageUrl': 'assets/images/back/pull_up.JPG', 'name': 'Pull Up'},
      {'imageUrl': 'assets/images/back/seated_row.JPG', 'name': 'Seated Row'},
    ],
    'Bicep': [
      {
        'imageUrl': 'assets/images/bicep/barbell_curls.JPG',
        'name': 'Barbell Curls'
      },
      {
        'imageUrl': 'assets/images/bicep/hammer_curls.JPG',
        'name': 'Hammer Curls'
      },
      {
        'imageUrl': 'assets/images/bicep/incline_dumbell_curls.JPG',
        'name': 'Incline Dumbell Curls'
      },
      {
        'imageUrl': 'assets/images/bicep/standing_biceps_cable_curl.JPG',
        'name': 'Standing Biceps Cable Curl'
      },
    ],
    'Chest': [
      {
        'imageUrl': 'assets/images/chest/bench_press.JPG',
        'name': 'Bench Press'
      },
      {
        'imageUrl': 'assets/images/chest/cable_cross_over.JPG',
        'name': 'Cable Cross Over'
      },
      {
        'imageUrl': 'assets/images/chest/incline_bench_press.JPG',
        'name': 'Incline Bench Press'
      },
      {'imageUrl': 'assets/images/chest/pec_fly.JPG', 'name': 'Pec Fly'},
      {'imageUrl': 'assets/images/chest/push_up.JPG', 'name': 'Push Up'},
    ],
    'Legs': [
      {
        'imageUrl': 'assets/images/legs/barbell_deadlift.JPG',
        'name': 'Barbell Deadlift'
      },
      {
        'imageUrl': 'assets/images/legs/barbell_front_squat.JPG',
        'name': 'Barbell Front Squat'
      },
      {
        'imageUrl': 'assets/images/legs/dumbell_lunges.JPG',
        'name': 'Dumbell Lunges'
      },
      {
        'imageUrl': 'assets/images/legs/leg_extension.JPG',
        'name': 'Leg Extension'
      },
      {'imageUrl': 'assets/images/legs/leg_press.JPG', 'name': 'Leg Press'},
      {
        'imageUrl': 'assets/images/legs/lying_leg_curl.JPG',
        'name': 'Lying Leg Curl'
      },
      {
        'imageUrl': 'assets/images/legs/seated_calf_raise.JPG',
        'name': 'Seated Calf Raise'
      },
    ],
    'Shoulder': [
      {
        'imageUrl': 'assets/images/shoulder/dumbbell_raise.JPG',
        'name': 'Dumbbell Raise'
      },
      {
        'imageUrl': 'assets/images/shoulder/dumbell_lateral_raise.JPG',
        'name': 'Dumbell Lateral Raise'
      },
      {
        'imageUrl': 'assets/images/shoulder/seated_barbell_shoulder_press.JPG',
        'name': 'Seated Barbell Shoulder Press'
      },
    ],
    'Tricep': [
      {
        'imageUrl': 'assets/images/tricep/cable_overhead_tricep_extension.JPG',
        'name': 'Cable Overhead Tricep Extension'
      },
      {
        'imageUrl': 'assets/images/tricep/seated_triceps_press.JPG',
        'name': 'Seated Triceps Press'
      },
    ],
  };

  Future<void> _showExerciseDialog(String imageUrl, String exerciseName, String category) async {
    int sets = 1;
    int reps = 1;

    TextEditingController setsController = TextEditingController(text: '$sets');
    TextEditingController repsController = TextEditingController(text: '$reps');

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
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            if (sets > 1) {
                              sets--;
                              setsController.text = '$sets';
                            }
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          controller: setsController,
                          onChanged: (newValue) {
                            setState(() {
                              sets = int.tryParse(newValue) ?? 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.green[600],
                        ),
                        onPressed: () {
                          setState(() {
                            sets++;
                            setsController.text = '$sets';
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reps:'),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            if (reps > 1) {
                              reps--;
                              repsController.text = '$reps';
                            }
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          controller: repsController,
                          onChanged: (newValue) {
                            setState(() {
                              reps = int.tryParse(newValue) ?? 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.green[600],
                        ),
                        onPressed: () {
                          setState(() {
                            reps++;
                            repsController.text = '$reps';
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
                    await _saveExercise(imageUrl, exerciseName, _selectedCategory! ,sets, reps);
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



  Future<void> _saveExercise(
       String imageUrl, String exerciseName, String category, int sets, int reps) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Get the reference to the user's workouts collection
    final workoutsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workoutplans');

    // Check if the workout for the selected day of the week already exists
    final workoutSnapshot = await workoutsRef
        .where('dayOfWeek', isEqualTo: widget.dayOfWeek)
        .limit(1)
        .get();

    // If the workout for the selected day of the week exists, update the document with the new exercise
    if (workoutSnapshot.docs.isNotEmpty) {
      final workoutDoc = workoutSnapshot.docs.first;
      final workoutData = workoutDoc.data();
      final exercises = workoutData['exercises'] as List;

      bool exerciseFound = false;

      // Check if the exercise with the same name already exists
      for (int i = 0; i < exercises.length; i++) {
        if (exercises[i]['name'] == exerciseName) {
          exerciseFound = true;

          

          // Update the exercise with the same name
          exercises[i]['imageUrl'] = imageUrl;
          exercises[i]['category'] = category;
          exercises[i]['sets'] = sets;
          exercises[i]['reps'] = reps;
          

          _scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('The exercise already exists!'),
              duration: Duration(seconds: 2),
            ),
          );
          break;
        }
      }

      if (!exerciseFound) {
        // If the exercise with the same name doesn't exist, add a new exercise
        exercises.add({
          'imageUrl': imageUrl,
          'name': exerciseName,
          'category': category,
          'sets': sets,
          'reps': reps,
        });
      }

      // Update the workout document with the modified exercises list
      await workoutsRef.doc(workoutDoc.id).update({
        'exercises': exercises,
      });
    } else {
      // If the workout for the selected day of the week doesn't exist, create a new document with the exercise
      await workoutsRef.add({
        'dayOfWeek': widget.dayOfWeek,
        'exercises': [
          {
            'imageUrl': imageUrl,
            'name': exerciseName,
            'sets': sets,
            'reps': reps,
          }
        ],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        final category = categories.keys.elementAt(index);
        final imageUrl = categories[category];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExercisesGrid() {
    if (_selectedCategory == null ||
        !exercisesByCategory.containsKey(_selectedCategory)) {
      return Center(child: Text('Select a category'));
    }

    final exercises = exercisesByCategory[_selectedCategory]!;

    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (BuildContext context, int index) {
        final exercise = exercises[index];
        final imageUrl = exercise['imageUrl'];
        final name = exercise['name'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedExerciseIndex = index;
            });
            _showExerciseDialog(imageUrl, name, _selectedCategory!);
          },
          child: Container(
            decoration: BoxDecoration(
              border: _selectedExerciseIndex == index
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: ListTile(
              leading: Image.asset(imageUrl!),
              title: Text(name!),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.dayOfWeek} - Exercises'),
        ),
        body: Column(
          children: [
            SizedBox(height: 8),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = categories.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedCategory == category
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _selectedCategory == null
                    ? Center(child: Text('Select a category'))
                    : _buildExercisesGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
