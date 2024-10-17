import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // State variables
  bool _isPasswordVisible = false;
  bool _isRememberMeChecked = false; // State for Remember Me checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full blue background
          Container(
            color: Colors.indigo[900], // Full blue background
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 100, // Position the text vertically
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'SITAMA',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Form content with white background and rounded top border
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 150), // Adjust spacing to push form down
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20), // Rounded only at the top
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                                height:
                                    30), // Space between white container and first TextField
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'ilhamajirawan@gmail.com',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextField(
                              obscureText:
                                  !_isPasswordVisible, // Toggle visibility
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '**********',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Change the icon based on the password visibility state
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    // Toggle the state of password visibility
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isRememberMeChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          // Toggle the value when checkbox is clicked
                                          _isRememberMeChecked = value!;
                                        });
                                      },
                                    ),
                                    Text('Remember me'),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Add login functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text('Or'),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            SizedBox(height: 40),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Add Google sign-in functionality
                              },
                              icon: Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              label: Text('Continue with Google'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
