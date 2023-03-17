import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildHeader(),
            SizedBox(height: 16),
            _buildSettingsButton(),
            SizedBox(height: 16),
            _buildMenu(),
            SizedBox(height: 16),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        Positioned(
          left: 80,
          top: 50,
          child: Text(
            'Username',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            print('Settings button pressed');
          },
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            print('Photo grid button pressed');
          },
          icon: Icon(Icons.grid_on),
        ),
        IconButton(
          onPressed: () {
            print('Body measurements button pressed');
          },
          icon: Icon(Icons.accessibility),
        ),
      ],
    );
  }

  Widget _buildContent() {
    // Replace this with the content you want to display.
    // You can use a StatefulWidget to manage the selected menu item and show the appropriate content.
    return Center(child: Text('Content goes here'));
  }

  }
