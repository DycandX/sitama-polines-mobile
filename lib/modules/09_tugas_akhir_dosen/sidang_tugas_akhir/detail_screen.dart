import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String nim;
  final String name;
  final String tahunAkademik;
  final String judulTA;
  final String ruangan;
  final String sebagai;
  final String isiBobotNaskah;
  final String penguasaanMateri;
  final bool isTerjadwal;  // Variabel untuk status terjadwal
  final Function(Map<String, dynamic>) onSave;

  DetailScreen({
    required this.nim,
    required this.name,
    required this.tahunAkademik,
    required this.judulTA,
    required this.ruangan,
    required this.sebagai,
    required this.isiBobotNaskah,
    required this.penguasaanMateri,
    required this.isTerjadwal,
    required this.onSave,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController nimController;
  late TextEditingController nameController;
  late TextEditingController tahunAkademikController;
  late TextEditingController judulTAController;
  late TextEditingController ruanganController;

  // Variables for the dropdowns
  late String selectedSebagai;
  late String selectedIsiBobotNaskah;
  late String selectedPenguasaanMateri;

  // Status "Terjadwal" atau "Belum Terjadwal"
  late bool isTerjadwal;

  // Dropdown options
  final sebagaiOptions = ['Pembimbing 1', 'Pembimbing 2', 'Penguji 1', 'Penguji 2'];
  final scoreOptions = ['100', '90', '80', '70', '60', '50'];

  @override
  void initState() {
    super.initState();
    nimController = TextEditingController(text: widget.nim);
    nameController = TextEditingController(text: widget.name);
    tahunAkademikController = TextEditingController(text: widget.tahunAkademik);
    judulTAController = TextEditingController(text: widget.judulTA);
    ruanganController = TextEditingController(text: widget.ruangan);

    // Inisialisasi dropdown
    selectedSebagai = sebagaiOptions.contains(widget.sebagai)
        ? widget.sebagai
        : sebagaiOptions.first;
    selectedIsiBobotNaskah = scoreOptions.contains(widget.isiBobotNaskah)
        ? widget.isiBobotNaskah
        : scoreOptions.first;
    selectedPenguasaanMateri = scoreOptions.contains(widget.penguasaanMateri)
        ? widget.penguasaanMateri
        : scoreOptions.first;

    // Inisialisasi status terjadwal
    isTerjadwal = widget.isTerjadwal;
  }

  @override
  void dispose() {
    nimController.dispose();
    nameController.dispose();
    tahunAkademikController.dispose();
    judulTAController.dispose();
    ruanganController.dispose();
    super.dispose();
  }

  void saveData() {
    Map<String, dynamic> updatedData = {
      'nim': nimController.text,
      'name': nameController.text,
      'tahunAkademik': tahunAkademikController.text,
      'judulTA': judulTAController.text,
      'ruangan': ruanganController.text,
      'sebagai': selectedSebagai,
      'isiBobotNaskah': selectedIsiBobotNaskah,
      'penguasaanMateri': selectedPenguasaanMateri,
      'isTerjadwal': isTerjadwal,  // Simpan status terjadwal
    };

    // Debugging untuk mengecek status terjadwal
    print('Status Terjadwal: $isTerjadwal');

    // Call the onSave callback dengan data yang telah diperbarui
    widget.onSave(updatedData);

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Nilai Ujian Sidang Tugas Akhir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Back to previous page
          },
        ),
        actions: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile_image.jpg'), // Ganti dengan gambar profil
          ),
          const SizedBox(width: 16), // Padding antara avatar dan tepi kanan
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Untuk memastikan layar bisa di-scroll jika konten banyak
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tahunAkademikController,
                decoration: const InputDecoration(
                  labelText: 'Tahun Akademik',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: judulTAController,
                decoration: const InputDecoration(
                  labelText: 'Judul TA',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ruanganController,
                decoration: const InputDecoration(
                  labelText: 'Ruangan',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSebagai,
                items: sebagaiOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedSebagai = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Sebagai',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedIsiBobotNaskah,
                items: scoreOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedIsiBobotNaskah = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Isi Dan Bobot Naskah',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPenguasaanMateri,
                items: scoreOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPenguasaanMateri = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Penguasaan Materi',
                ),
              ),
              const SizedBox(height: 32),
              // Switch untuk status Terjadwal atau Belum Terjadwal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Terjadwal'),
                  Switch(
                    value: isTerjadwal,
                    onChanged: (bool value) {
                      setState(() {
                        isTerjadwal = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: saveData,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}