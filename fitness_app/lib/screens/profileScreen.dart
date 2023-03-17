import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

   String _selectedMenuItem = 'grid';
  List<String> photos = List.generate(
    9,
    (index) => Faker().image.image(width: 200, height: 200, keywords: countries ));
 
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'edit_profile') {
                print('Edit profile selected');
              } else if (value == 'logout') {
                print('Logout selected');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Text('Edit Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
            icon: Icon(Icons.menu),
            offset: Offset(0, kToolbarHeight),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildHeader(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
              SizedBox(height: 8),
              Text(
                'Username',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCounter('Posts', 50),
                    _buildCounter('Followers', 100),
                    _buildCounter('Following', 200),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  
   Widget _buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedMenuItem = 'grid';
            });
          },
          icon: Icon(Icons.grid_on),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _selectedMenuItem = 'info';
            });
          },
          icon: Icon(Icons.accessibility),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_selectedMenuItem == 'grid') {
      return _buildPhotoGrid();
    } else {
      return _buildMeasurementsContent();
    }
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        // Display the images in the newest order.
        String imageUrl = photos[photos.length - 1 - index];

        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}

 Widget _buildMeasurementsContent() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/human_body.png'), 
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age:'), // Add the Age field
            SizedBox(height: 8),
            Text('Gender:'), // Add the Gender field
            SizedBox(height: 8),
            Text('Height:'), // Add the Height field
            SizedBox(height: 8),
            Text('Weight:'), // Add the Weight field
            SizedBox(height: 8),
            Text('BMI:'), // Add the BMI field
            SizedBox(height: 8),
            Text('Waist:'), // Add the Waist field
            SizedBox(height: 8),
            Text('Hip:'), // Add the Hip field
            SizedBox(height: 8),
            Text('Forearm:'), // Add the Forearm field
            SizedBox(height: 8),
            Text('Neck:'), // Add the Neck field
            SizedBox(height: 8),
            Text('Abdomen:'), // Add the Abdomen field
            SizedBox(height: 8),
            Text('Body Fat:'), // Add the Body Fat field
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  
