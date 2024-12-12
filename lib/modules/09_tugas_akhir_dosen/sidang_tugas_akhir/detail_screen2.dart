import 'package:flutter/material.dart';

class DetailScreen2 extends StatefulWidget {
  final String nim;
  final String name;
  final String tahunAkademik;
  final String judulTA;
  final String ruangan;
  final String sebagai; // Role that should not be changeable
  final String isiBobotNaskah;
  final String penguasaanMateri;
  final String presentasiPenampilan; // New field
  final String hasilRancangBangun; // New field
  final Function(Map<String, dynamic>) onSave;

  const DetailScreen2({
    super.key,
    required this.nim,
    required this.name,
    required this.tahunAkademik,
    required this.judulTA,
    required this.ruangan,
    required this.sebagai,
    required this.isiBobotNaskah,
    required this.penguasaanMateri,
    required this.presentasiPenampilan, // New field
    required this.hasilRancangBangun, // New field
    required this.onSave,
  });

  @override
  _DetailScreen2State createState() => _DetailScreen2State();
}

class _DetailScreen2State extends State<DetailScreen2> {
  late TextEditingController nimController;
  late TextEditingController nameController;
  late TextEditingController tahunAkademikController;
  late TextEditingController judulTAController;
  late TextEditingController ruanganController;
  late TextEditingController isiBobotNaskahController;
  late TextEditingController penguasaanMateriController;
  late TextEditingController presentasiPenampilanController;
  late TextEditingController hasilRancangBangunController;

  @override
  void initState() {
    super.initState();
    nimController = TextEditingController(text: widget.nim);
    nameController = TextEditingController(text: widget.name);
    tahunAkademikController = TextEditingController(text: widget.tahunAkademik);
    judulTAController = TextEditingController(text: widget.judulTA);
    ruanganController = TextEditingController(text: widget.ruangan);
    isiBobotNaskahController =
        TextEditingController(text: widget.isiBobotNaskah);
    penguasaanMateriController =
        TextEditingController(text: widget.penguasaanMateri);
    presentasiPenampilanController = TextEditingController(
        text: widget.presentasiPenampilan); // Initialize with existing data
    hasilRancangBangunController = TextEditingController(
        text: widget.hasilRancangBangun); // Initialize with existing data
  }

  @override
  void dispose() {
    nimController.dispose();
    nameController.dispose();
    tahunAkademikController.dispose();
    judulTAController.dispose();
    ruanganController.dispose();
    isiBobotNaskahController.dispose();
    penguasaanMateriController.dispose();
    presentasiPenampilanController.dispose();
    hasilRancangBangunController.dispose();
    super.dispose();
  }

  void saveData() {
    Map<String, dynamic> updatedData = {
      'nim': nimController.text,
      'name': nameController.text,
      'tahunAkademik': tahunAkademikController.text,
      'judulTA': judulTAController.text,
      'ruangan': ruanganController.text,
      'sebagai': widget.sebagai, // Use the fixed role
      'isiBobotNaskah': isiBobotNaskahController.text,
      'penguasaanMateri': penguasaanMateriController.text,
      'presentasiPenampilan': presentasiPenampilanController.text,
      'hasilRancangBangun': hasilRancangBangunController.text,
    };

    widget.onSave(updatedData);
    Navigator.pop(context);
  }

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

  @override
  Widget build(BuildContext context) {
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
              // Replace DropdownButtonFormField with TextFormField for the fixed role
              TextFormField(
                controller: TextEditingController(text: widget.sebagai),
                decoration: readOnlyDecoration('Sebagai'),
                readOnly: true, // Make this field read-only
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: isiBobotNaskahController,
                decoration:
                    const InputDecoration(labelText: 'Isi Dan Bobot Naskah'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: penguasaanMateriController,
                decoration:
                    const InputDecoration(labelText: 'Penguasaan Materi'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: presentasiPenampilanController,
                decoration: const InputDecoration(
                    labelText: 'Presentasi dan Penampilan'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hasilRancangBangunController,
                decoration:
                    const InputDecoration(labelText: 'Hasil Rancang Bangun'),
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
