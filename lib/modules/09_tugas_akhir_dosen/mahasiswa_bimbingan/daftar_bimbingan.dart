import 'package:flutter/material.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/dataMhs_ta.dart';
import 'package:pbl_sitama/modules/09_tugas_akhir_dosen/mahasiswa_bimbingan/mahasiswa_bimbingan.dart';

class DaftarBimbingan extends StatefulWidget {
  const DaftarBimbingan({super.key});

  @override
  State<DaftarBimbingan> createState() => _DaftarBimbinganState();
}

class _DaftarBimbinganState extends State<DaftarBimbingan> {
  final List<Map<String, dynamic>> guidanceList = [
    {"title": "Bimbingan 1", "status": "Diverifikasi", "isVerified": true},
    {"title": "Bimbingan 2", "status": "Diverifikasi", "isVerified": true},
    {"title": "Bimbingan 3", "status": "Diverifikasi", "isVerified": true},
    {"title": "Bimbingan 4", "status": "Diverifikasi", "isVerified": true},
    {"title": "Bimbingan 5", "status": "Diverifikasi", "isVerified": true},
    {
      "title": "Bimbingan 6",
      "status": "Belum Diverifikasi",
      "isVerified": false
    },
    {
      "title": "Bimbingan 7",
      "status": "Belum Diverifikasi",
      "isVerified": false
    },
    {
      "title": "Bimbingan 8",
      "status": "Belum Diverifikasi",
      "isVerified": false
    },
  ];

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MahasiswaBimbingan()),
                        );
                      },
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
            // Title Row for "Daftar Bimbingan" and count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daftar Bimbingan Saifullah",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                  ),
                  Text("8/8", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // List of Bimbingan
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: guidanceList.length,
                itemBuilder: (context, index) {
                  final guidance = guidanceList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        guidance["title"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: guidance["isVerified"]
                                ? Colors.green
                                : Colors.orange,
                          ),
                          SizedBox(width: 6),
                          Text(
                            guidance["status"],
                            style: TextStyle(
                              color: guidance["isVerified"]
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DatamhsTa()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Lihat",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Approve Button at the Bottom
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                    child: Text(
                  "Setujui Sidang",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
