
import 'package:flutter/material.dart';



class Leaderboard extends StatefulWidget {
  static const String routeName = '/leaderboard'; // routename for navigator

  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}


class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.redAccent, // Set your desired color here
        ),
      ),
      child: DefaultTabController(
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
      ),
    );
  }

  Widget _buildBodyFatList() {
    return Center(
      child: Text('Top 10 Body Fat %'),
    );
  }

  

  Widget _buildPopularExercisesList() {
    return Center(
      child: Text('Top 10 Popular Exercises'),
    );
  }




  
}

