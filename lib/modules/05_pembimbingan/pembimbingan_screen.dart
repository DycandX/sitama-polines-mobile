import 'package:flutter/material.dart';
import 'daftar_bimbingan_screen.dart';

class PembimbinganScreen extends StatefulWidget {
  const PembimbinganScreen({Key? key}) : super(key: key);

  @override
  State<PembimbinganScreen> createState() => _PembimbinganScreenState();
}

class _PembimbinganScreenState extends State<PembimbinganScreen> {
  bool isDataPlotted = true; // This should come from the database
  String pembimbing1 = "Pembimbing 1";
  String pembimbing2 = "Pembimbing 2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDataPlotted
            ? Column(
                children: [
                  // Header Row with Back Button, Name, and Avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromRGBO(40, 42, 116, 1),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Adnan Bima Adhi N',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/profile.png'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pembimbing 1 Box
                  PembimbingBox(
                    pembimbing: pembimbing1,
                    statusText: "Lengkap",
                    statusColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarBimbinganScreen(pembimbing: pembimbing1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Pembimbing 2 Box
                  PembimbingBox(
                    pembimbing: pembimbing2,
                    statusText: "Belum Lengkap",
                    statusColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DaftarBimbinganScreen(pembimbing: pembimbing2),
                        ),
                      );
                    },
                  ),
                ],
              )
            : Container(
                color: Colors.yellow[100],
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Data Pembimbing belum di-plotting!',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
      ),
    );
  }
}

class PembimbingBox extends StatelessWidget {
  final String pembimbing;
  final String statusText;
  final Color statusColor;
  final VoidCallback onTap;

  const PembimbingBox({
    required this.pembimbing,
    required this.statusText,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pembimbing,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Wiktasari, S.T, M.Kom.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: statusColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              child: const Text(
                "Lihat",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
