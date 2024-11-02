import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String nim;
  final String name;
  final String tahunAkademik;
  final String judulTA;
  final String ruangan;
  final String sebagai;
  final String kedisiplinanBimbingan;
  final String kreativitasPemecahanMasalah;
  final String penguasaanMateri;
  final String kelengkapanReferensi;
  final Function(Map<String, dynamic>) onSave;

  const DetailScreen({
    super.key,
    required this.nim,
    required this.name,
    required this.tahunAkademik,
    required this.judulTA,
    required this.ruangan,
    required this.sebagai,
    required this.kedisiplinanBimbingan,
    required this.kreativitasPemecahanMasalah,
    required this.penguasaanMateri,
    required this.kelengkapanReferensi,
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
  late TextEditingController kedisiplinanBimbinganController;
  late TextEditingController kreativitasPemecahanMasalahController;
  late TextEditingController penguasaanMateriController;
  late TextEditingController kelengkapanReferensiController;

  // Dropdown options
  final sebagaiOptions = [
    'Pembimbing 1',
    'Pembimbing 2',
    'Penguji 1',
    'Penguji 2'
  ];

  late String selectedSebagai;

  @override
  void initState() {
    super.initState();
    nimController = TextEditingController(text: widget.nim);
    nameController = TextEditingController(text: widget.name);
    tahunAkademikController = TextEditingController(text: widget.tahunAkademik);
    judulTAController = TextEditingController(text: widget.judulTA);
    ruanganController = TextEditingController(text: widget.ruangan);
    kedisiplinanBimbinganController =
        TextEditingController(text: widget.kedisiplinanBimbingan);
    kreativitasPemecahanMasalahController =
        TextEditingController(text: widget.kreativitasPemecahanMasalah);
    penguasaanMateriController =
        TextEditingController(text: widget.penguasaanMateri);
    kelengkapanReferensiController =
        TextEditingController(text: widget.kelengkapanReferensi);

    // Initialize dropdown selection
    selectedSebagai = sebagaiOptions.contains(widget.sebagai)
        ? widget.sebagai
        : sebagaiOptions.first;
  }

  @override
  void dispose() {
    nimController.dispose();
    nameController.dispose();
    tahunAkademikController.dispose();
    judulTAController.dispose();
    ruanganController.dispose();
    kedisiplinanBimbinganController.dispose();
    kreativitasPemecahanMasalahController.dispose();
    penguasaanMateriController.dispose();
    kelengkapanReferensiController.dispose();
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
      'kedisiplinanBimbingan': kedisiplinanBimbinganController.text,
      'kreativitasPemecahanMasalah': kreativitasPemecahanMasalahController.text,
      'penguasaanMateri': penguasaanMateriController.text,
      'kelengkapanReferensi': kelengkapanReferensiController.text,
    };

    widget.onSave(updatedData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration readOnlyDecoration(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Nilai Ujian Sidang Tugas Akhir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          const CircleAvatar(
            backgroundImage:
                NetworkImage('https://example.com/profile_image.jpg'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nimController,
                decoration: readOnlyDecoration('NIM'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: readOnlyDecoration('Nama'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tahunAkademikController,
                decoration: readOnlyDecoration('Tahun Akademik'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: judulTAController,
                decoration: readOnlyDecoration('Judul TA'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ruanganController,
                decoration: readOnlyDecoration('Ruangan'),
                readOnly: true,
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
                onChanged: null, // Disable dropdown selection
                decoration: readOnlyDecoration('Sebagai'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kedisiplinanBimbinganController,
                decoration: const InputDecoration(
                  labelText: 'Kedisiplinan dalam Bimbingan',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kreativitasPemecahanMasalahController,
                decoration: const InputDecoration(
                  labelText: 'Kreativitas Pemecahan Masalah',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: penguasaanMateriController,
                decoration: const InputDecoration(
                  labelText: 'Penguasaan Materi',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kelengkapanReferensiController,
                decoration: const InputDecoration(
                  labelText: 'Kelengkapan dan Referensi',
                ),
                keyboardType: TextInputType.number,
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
