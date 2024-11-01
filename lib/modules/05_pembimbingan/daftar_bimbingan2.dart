import 'package:flutter/material.dart';

class DaftarBimbingan2 extends StatefulWidget {
  final String pembimbing;

  const DaftarBimbingan2({required this.pembimbing, Key? key})
      : super(key: key);

  @override
  _DaftarBimbingan2State createState() => _DaftarBimbingan2State();
}

class _DaftarBimbingan2State extends State<DaftarBimbingan2> {
  List<Map<String, dynamic>> bimbinganList = [
    {'title': 'Bimbingan 1', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 2', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 3', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 4', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 5', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 6', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 7', 'status': 'Diverifikasi'},
    {'title': 'Bimbingan 8', 'status': 'Diverifikasi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button, name, and avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  color: const Color.fromRGBO(40, 42, 116, 1),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        'Adnan Bima Adhi N',
                        style: TextStyle(
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
            // Title and progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Bimbingan\n${widget.pembimbing}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${bimbinganList.length}/8',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of Bimbingan items
            Expanded(
              child: ListView.builder(
                itemCount: bimbinganList.length,
                itemBuilder: (context, index) {
                  var bimbingan = bimbinganList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
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
                              bimbingan['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  bimbingan['status'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement view bimbingan action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Lihat",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
