import 'package:fitness_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workoutPlan.dart';
import 'package:fitness_app/models/workout.dart';

class WorkoutCard extends StatefulWidget {
  final String exerciseName;
  final String muscleGroup;
  final String description;

  WorkoutCard({
    required this.exerciseName,
    required this.muscleGroup,
    required this.description,
  });

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 8),
            blurRadius: 8,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.exerciseName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.muscleGroup,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              widget.description,
              maxLines: isExpanded ? null : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            secondChild: Text(
              widget.description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Show less' : 'Show more',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
