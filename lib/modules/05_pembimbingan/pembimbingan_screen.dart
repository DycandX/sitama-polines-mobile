import 'package:flutter/material.dart';
import 'status_bimbingan_screen.dart';

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
      appBar: AppBar(
        title: const Text('Pembimbingan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDataPlotted
            ? Column(
                children: [
                  // Pembimbing 1 Box
                  PembimbingBox(
                    pembimbing: pembimbing1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StatusBimbinganScreen(pembimbing: pembimbing1)),
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
                                StatusBimbinganScreen(pembimbing: pembimbing2)),
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
