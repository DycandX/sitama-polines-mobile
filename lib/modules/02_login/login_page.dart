import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';
import 'package:http/http.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_navigation.dart';
import '../../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // State variables
  bool _isPasswordVisible = false;
  bool _isRememberMeChecked = false; // State for Remember Me checkbox
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(String email, String password) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      Response response = await post(
        Uri.parse('${Config.baseUrl}login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse response and extract token
        var data = jsonDecode(response.body);
        final token = data['token'];
        final role = data['role'];

        // Print login success for debugging
        print('Login successfully');
        print('Token: $token');

        // Set token using Provider
        Provider.of<AuthProvider>(context, listen: false).setToken(token);

        // Navigate based on user type
        if (role.contains("dosen")) {
          context.go('/home');
        } else if (role.contains("mahasiswa")){
          // Navigate to homeMahasiswaScreen for students
          context.go('/home_mahasiswa');
        }
      } else {
        // Show error dialog if login fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Incorrect email or password."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");

      // Show error dialog for network or server errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("An error occurred: ${e.toString()}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

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
                const SizedBox(height: 150), // Adjust spacing to push form down
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20), // Rounded only at the top
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
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
                            const SizedBox(
                                height:
                                    30), // Space between white container and first TextField
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'dewa@gmail.com',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextField(
                              controller: _passwordController,
                              obscureText:
                                  !_isPasswordVisible, // Toggle visibility
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '',
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
                            const SizedBox(height: 25),
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
                                    const Text('Remember me'),
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
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _login(
                                  _emailController.text.toString(),
                                  _passwordController.text.toString()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('Or'),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 40),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Add Google sign-in functionality
                              },
                              icon: Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              label: const Text('Continue with Google'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                side: const BorderSide(color: Colors.grey),
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
