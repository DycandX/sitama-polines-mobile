import 'package:flutter/material.dart';

class DatamhsTa extends StatefulWidget {
  const DatamhsTa({super.key});

  @override
  State<DatamhsTa> createState() => _DatamhsTaState();
}

class _DatamhsTaState extends State<DatamhsTa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      backgroundImage: AssetImage('assets/images/xaviera.png'),
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            // Title Text
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Data Mahasiswa Bimbingan Tugas Akhir",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Student Info Card
            SizedBox(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildInfoRow("NIM", "3.23.29.0.34"),
                          _buildInfoRow("Nama", "Saifullah"),
                          _buildInfoRow("Tahun Bimbingan", "2024"),
                          _buildInfoRow("Judul Bimbingan",
                              "Sistem Absensi Berbasis AI Yang Terintegrasi Dengan IoT"),
                          SizedBox(height: 10),
                          // File Button Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("File"),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Lihat File",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Approval Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 130,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                  ),
                                  child: Text("Tidak Setuju",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                  ),
                                  child: Text(
                                    "Setuju",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build rows of student information
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
