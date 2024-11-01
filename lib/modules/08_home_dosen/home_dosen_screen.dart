import 'package:flutter/material.dart';

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
      home: JadwalSidangPage(),
    );
  }
}

class JadwalSidangPage extends StatefulWidget {
  @override
  _JadwalSidangPageState createState() => _JadwalSidangPageState();
}

class _JadwalSidangPageState extends State<JadwalSidangPage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> jadwalSidang = [
    {'hari': 'Rabu', 'tanggal': '2 Oktober 2024'},
    {'hari': 'Kamis', 'tanggal': '3 Oktober 2024'},
    {'hari': 'Jum\'at', 'tanggal': '4 Oktober 2024'},
    {'hari': 'Senin', 'tanggal': '7 Oktober 2024'},
    {'hari': 'Selasa', 'tanggal': '8 Oktober 2024'},
    {'hari': 'Rabu', 'tanggal': '9 Oktober 2024'},
    {'hari': 'Kamis', 'tanggal': '10 Oktober 2024'},
    {'hari': 'Jum\'at', 'tanggal': '11 Oktober 2024'},
    {'hari': 'Senin', 'tanggal': '14 Oktober 2024'},
    {'hari': 'Selasa', 'tanggal': '15 Oktober 2024'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0068FF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Image.asset('images/back.png'),
                iconSize: 24,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Row(
              children: [
                Text(
                  'WIKTASARI , S.T., M.Kom.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Sidang Tugas Akhir',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: jadwalSidang.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${jadwalSidang[index]['hari']}, ${jadwalSidang[index]['tanggal']}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0068FF),
                        ),
                        child: Text(
                          'Lihat',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/home.png',
                  width: 32,
                  height: 32,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/bimbingan.png',
                  width: 32,
                  height: 32,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                ),
                label: 'Bimbingan',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/menguji.png',
                  width: 32,
                  height: 32,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                ),
                label: 'Menguji',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/profile.png',
                  width: 32,
                  height: 32,
                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282A74), // Warna latar belakang halaman profil
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity, // Mengisi penuh secara horizontal
              height: 480,
              margin:
                  EdgeInsets.only(top: 50), // Kontainer lebih rendah sedikit
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
                  SizedBox(
                      height:
                          40), // Jarak dari foto profil agar konten tidak bertabrakan
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
                  SizedBox(height: 40), // Atur jarak agar tombol lebih ke atas
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna tombol merah
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
                      style:
                          TextStyle(color: Colors.white), // Teks berwarna putih
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [Column()],
          ),
          // Foto Profil dengan Penyesuaian
          Positioned(
            top: 180, // Posisikan ikon profil sedikit di atas kontainer putih
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 50, // Ukuran foto profil
                backgroundColor:
                    Colors.white, // Opsional agar ada outline putih
                child: ClipOval(
                  child: Image.asset(
                    'images/pr-50.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit
                        .cover, // Memastikan gambar memenuhi area tanpa distorsi
                  ),
                ),
              ),
            ),
          ),
          // Teks 'Profile' di bagian atas
          Positioned(
            top: 150, // Posisi teks Profile di bagian atas
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
}
