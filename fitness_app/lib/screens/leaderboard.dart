
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Leaderboard extends StatefulWidget {
  static const String routeName = '/leaderboard'; // routename for navigator

  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Body Fat %'),
              
              Tab(text: 'Popular Exercises'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBodyFatList(),
            
            _buildPopularExercisesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFatList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .orderBy('bodyFat', descending: false)
        .limit(10)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Something went wrong'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final userDocs = snapshot.data!.docs;

      return ListView.builder(
        itemCount: userDocs.length,
        itemBuilder: (context, index) {
          final user = userDocs[index];
          return ListTile(
            leading: CircleAvatar(child: Text((index + 1).toString())),
            title: Text(user['userName'] ?? 'Unknown'),
            trailing: Text('${user['bodyFat']}%'),
          );
        },
      );
    },
  );
}

  

  Widget _buildPopularExercisesList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('leaderboard')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Something went wrong'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final leaderboardDocs = snapshot.data!.docs;
      final topExercises = <Map<String, dynamic>>[];

      leaderboardDocs.forEach((doc) {
        (doc.data() as Map<String, dynamic>).forEach((exercise, count) {
          topExercises.add({'exercise': exercise, 'count': count});
        });
      });

      topExercises.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      final top15Exercises =
          topExercises.length > 15 ? topExercises.sublist(0, 15) : topExercises;

      return ListView.builder(
        itemCount: top15Exercises.length,
        itemBuilder: (context, index) {
          final exercise = top15Exercises[index];
          return ListTile(
            leading: CircleAvatar(child: Text((index + 1).toString())),
            title: Text(exercise['exercise']),
            trailing: Text(exercise['count'].toString()),
          );
        },
      );
    },
  );
}
  
}

