import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/03_home_mahasiswa/home_mahasiswa_screen.dart';
import 'package:pbl_sitama/modules/08_home_dosen/home_dosen_screen.dart';

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

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Check if entered credentials match the predefined credentials
    // if (email == "mahasiswa@gmail.com" && password == "12345678") {
    //   // Navigate to homeMahasiswaScreen if credentials are correct
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => homeMahasiswaScreen(),
    //     ),
    //   );
    if (email == "dosen@gmail.com" && password == "12345678") {
      // Navigate to homeMahasiswaScreen if credentials are correct
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JadwalSidangPage(),
        ),
      );
    } else {
      // Show error message if credentials are incorrect
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
                              onPressed: _login,
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