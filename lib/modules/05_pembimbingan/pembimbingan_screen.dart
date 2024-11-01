import 'package:flutter/material.dart';
import 'daftar_bimbingan_screen.dart';

class PembimbinganScreen extends StatefulWidget {
  const PembimbinganScreen({Key? key}) : super(key: key);

  @override
  State<PembimbinganScreen> createState() => _PembimbinganScreenState();
}

class _PembimbinganScreenState extends State<PembimbinganScreen> {
  bool isDataPlotted = true; // Ini seharusnya datang dari database
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
                        padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: const Color.fromRGBO(40, 42, 116, 1),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                            child: Text(
                              'XAVIERA PUTRI S.T, M.Kom.',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w100,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/xaviera.png'),
                            backgroundColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Pembimbing 1 Box
                  PembimbingBox(
                    pembimbing: pembimbing1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DaftarBimbinganScreen(pembimbing: pembimbing1)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Pembimbing 2 Box
                  PembimbingBox(
                    pembimbing: pembimbing2,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DaftarBimbinganScreen(pembimbing: pembimbing2)),
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
  final VoidCallback onTap;

  const PembimbingBox({
    required this.pembimbing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pembimbing,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
