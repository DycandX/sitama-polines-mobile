import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../02_login/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Sidang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 10, // Adjusted for better alignment
        toolbarHeight: 10, // Adjusted height for better header presentation
        backgroundColor: Color(0xFF282A74),
      ),
      backgroundColor:
          Color(0xFF282A74), // Background color for the profile page
      body: Stack(
        children: [
          // GestureDetector(
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.blueAccent,
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.arrow_back,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              height: 480,
              margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 40), // Space to avoid overlapping content
                  Text(
                    'WIKTASARI, S.T., M.Kom.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NIP: 123456789',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 40), // Space above the button
                  ElevatedButton(
                    onPressed: () {
                      _showLogoutConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red button color
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text(
                      'LOG OUT',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Profile Photo
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: ClipOval(
                    // child: Image.asset(
                    //   '',
                    //   width: 100, // Adjust width and height to fit within CircleAvatar
                    //   height: 100,
                    //   fit: BoxFit.cover,
                    // ),
                    ),
              ),
            ),
          ),
          // 'Profile' text at the top
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Apakah Anda Yakin Ingin Keluar?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // No Button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Colors.red),
                  ),
                  // Yes Button
                  IconButton(
                    onPressed: () {
                      _logout(context);
                      Navigator.of(context).pop(); // Close dialog
                    },
                    icon: Icon(Icons.check, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    // Clear token from SharedPreferences (or other storage)
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // assuming you stored the token under the key 'token'

    context.go('/login');
    // Redirect to the login screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginPage())
    // );
  }
}
