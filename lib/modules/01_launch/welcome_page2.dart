import 'package:flutter/material.dart';
import 'package:sitama/main.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage3(),
    );
  }
}

class WelcomePage3 extends StatelessWidget {
  const WelcomePage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Row to position TextButton in the top right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Action when the text is pressed
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const WelcomePage3(), // Navigate to WelcomePage3
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Transition from right to left
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Lewati', // Clickable text above the image
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors
                          .grey, // Change color to indicate it's clickable
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Space between text and image

            // Image Section (Replace with your image asset)
            Center(
              child: Image.asset(
                "../images/welcome_image3.png", // Replace with actual image path
                height: 500,
                width: 350,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            // Text Section
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Memudahkan Administrasi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Fokus pada penelitian dan penulisan tugas akhir mulai dari pengajuan hingga persetujuan.',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal),
              ),
            ),
            const Spacer(),
            // Page Indicator and Navigation Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.grey),
                    SizedBox(width: 5),
                    Icon(Icons.circle, size: 10, color: Colors.grey),
                    SizedBox(width: 5),
                    Icon(Icons.circle,
                        size: 10, color: Color.fromARGB(255, 8, 0, 255)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const WelcomePage(), // Halaman tujuan baru
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Geser dari kanan ke kiri
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor:
                        const Color.fromARGB(255, 8, 0, 255), // Warna tombol
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
