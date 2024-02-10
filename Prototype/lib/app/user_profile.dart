import 'package:flutter/material.dart';
import 'package:prototype/app/authenticate/start_screen.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => StartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('images/user.jpg'), // Replace with your user's profile image
          ),
          SizedBox(height: 16.0),
          Text(
            'Nottingham',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'example@nottingham.edu.cn',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Role'),
            subtitle: Text('Manager'), // Replace with the user's phone number
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone Number'),
            subtitle: Text('+123 456 7890'), // Replace with the user's phone number
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            subtitle: Text('Ningbo, China'), // Replace with the user's location
          ),
          // Add more ListTile widgets for additional user details

          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle the edit functionality here
              // You can navigate to an edit screen or show a dialog for editing
              // For now, let's print a message
              print('Edit button pressed');
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }
}
