 
// class WorkoutPage extends StatelessWidget {
//   final List<Map<String, dynamic>> categories = [    {      'name': 'Chest',      'image': 'assets/images/chest-main.jpg',      'subcategories': [        {          'name': 'Bench Press',          'image': 'assets/images/chest/bench_press.jpg',        },        {          'name': 'Cable Cross Over',          'image': 'assets/images/chest/cable_cross_over.jpg',        },      ],
//     },
//     {
//       'name': 'Back',
//       'image': 'assets/images/back-main.jpg',
//       'subcategories': [        {          'name': 'Lat Pull-Down',          'image': 'assets/images/back/lat_pull_down.jpg',        },        {          'name': 'Pull-Up',          'image': 'assets/images/back/pull_up.jpg',        },      ],
//     },
//   ];

 import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {

  final List<Map<String, dynamic>> categories = [   
     {      
      'name': 'Chest','image': 'assets/images/chest_main.jpg', 
      'subcategories': [
        {'name': 'Bench Press','image': 'assets/images/chest/bench_press.jpg',},        
      { 'name': 'Cable Cross Over', 'image': 'assets/images/chest/cable_cross_over.jpg',},      
      ],
     },
     {
       'name': 'Back','image': 'assets/images/back_main.jpg',
       'subcategories': 
       [
        {'name': 'Lat Pull-Down','image': 'assets/images/back/lat_pull_down.jpg',},
       {'name': 'Pull-Up', 'image': 'assets/images/back/pull_up.jpg',},
       ],
     },
 ];

   WorkoutPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubcategoryPage(
                    category: categories[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(categories[index]['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    categories[index]['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class SubcategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  SubcategoryPage({required this.category});

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> subcategories = widget.category['subcategories'];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category['name']),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              
              padding: EdgeInsets.all(10),
              itemCount: subcategories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // TODO: Implement subcategory tap functionality
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(subcategories[index]['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    subcategories[index]['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}