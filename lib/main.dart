import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/02_login/login_page.dart';
import 'package:pbl_sitama/modules/06_daftar_tugas_akhir/daftar_ta_screen.dart';
// import 'package:pbl_sitama/modules/04_dashboard_tugas_akhir/dasboard_ta_tampilkan.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Daftartascreen(),
      //home: DashboardTaTampilan(),
      //home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Lewati Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // PageView untuk carousel
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [
                  SlidingContent(
                    imagePath: "assets/images/welcome_image.png",
                    title: 'Kemudahan Setiap Langkah',
                    description:
                        'Nikmati kemudahan dalam mengelola proses tugas akhir Anda. Dari pengajuan proposal hingga persiapan sidang, semua terintegrasi dalam satu platform.',
                  ),
                  SlidingContent(
                    imagePath: "assets/images/welcome_image2.png",
                    title: 'Efisiensi Membimbing',
                    description:
                        'Pantau progress mahasiswa, berikan feedback secara real-time, dan jadwalkan sidang dengan mudah.',
                  ),
                  SlidingContent(
                    imagePath: "assets/images/welcome_image3.png",
                    title: 'Memudahkan Administrasi',
                    description:
                        'Fokus pada penelitian dan penulisan tugas akhir mulai dari pengajuan hingga persetujuan.',
                  ),
                ],
              ),
            ),

            // Indicator dan Next Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicators
                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: _currentIndex == index
                            ? const Color.fromARGB(255, 8, 0, 255)
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
                // Next Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < 2) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Mengarahkan ke LoginPage setelah halaman terakhir
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: const Color.fromARGB(255, 8, 0, 255),
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

class SlidingContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const SlidingContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            imagePath,
            height: 400,
            width: 350,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
