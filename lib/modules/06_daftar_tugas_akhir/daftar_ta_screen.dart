  import 'dart:convert';
  import 'dart:io';
  import 'package:file_picker/file_picker.dart';
  import 'package:go_router/go_router.dart';
  import 'package:http/http.dart' as http;

  import 'package:crypto/crypto.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_pdfview/flutter_pdfview.dart';
  import 'package:path_provider/path_provider.dart';
  import 'package:pbl_sitama/services/api_service.dart';
  import 'package:provider/provider.dart';
  import 'daftar_ta_controller.dart';
  import 'daftar_ta_input.dart';

  class DaftarTaScreen extends StatefulWidget {
    const DaftarTaScreen({super.key});

    @override
    State<DaftarTaScreen> createState() => _DaftarTaScreenState();
  }

  String generateShortFileName(String url) {
    final bytes = utf8.encode(url); // Convert the URL to bytes
    final hash = sha1.convert(bytes); // Generate SHA1 hash
    return hash.toString().substring(0, 40); // Safely use the full length of SHA1 hash
  }

  Future<void> downloadAndOpenPdf(BuildContext context, String url, String fileName) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/pdf',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to download PDF. Status code: ${response.statusCode}");
      }

      final Directory directory = await getTemporaryDirectory();
      final String safeFileName = generateShortFileName(url) + '.pdf';
      final String filePath = '${directory.path}/$safeFileName';

      await File(filePath).writeAsBytes(response.bodyBytes);

      // Check if the file exists before navigating
      final File file = File(filePath);
      if (await file.exists()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(pdfPath: filePath),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF file could not be found.')),
        );
      }
    } catch (e, stackTrace) {
      print("Download Error: $e");
      print("Stack Trace: $stackTrace");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading PDF: ${e.toString()}'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


  String truncateFileName(String fileName, {int maxLength = 50}) {
    if (fileName.length > maxLength) {
      return fileName.substring(0, maxLength) + '.pdf';
    }
    return fileName;
  }

  class _DaftarTaScreenState extends State<DaftarTaScreen> {
    String? mhsNama;
    int? dataSidang;
    int? partner_valid;
    Map<String, dynamic>? partner;

    final DaftarTAController _controller = DaftarTAController();
    bool _isLoading = true;

    Future<void> loadMahasiswaData(String token) async {
      try {
        final data = await ApiService.fetchMahasiswa(token);

        setState(() {
          mhsNama = data['mahasiswa']['mhs_nama'];
          dataSidang = data['taSidang']?['ta_sidang_id'];
          partner = data['partner'];
          partner_valid = data['partner_valid'];
        });
        // Fetch daftar tugas
        await _controller.fetchDaftarTugas(token);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }

    String? userName;
    @override
    void initState() {
      super.initState();

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      userName = authProvider.userName;
      if (token != null) {
        loadMahasiswaData(token);
      } else {
        print('User is not authenticated');
        setState(() {
          _isLoading = false;
        });
      }
    }

    final DaftarTAController controller = DaftarTAController();
    final UploadController _uploadController = UploadController();

    String? selectedFile;

    Future<void> _pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          selectedFile = result.files.single.name;
        });
      }
    }

    Future<bool> _onWillPop() async {
      // Menavigasi kembali jika tidak ada masalah
      Navigator.pop(context);
      GoRouter.of(context).pushReplacement('/home_mahasiswa');

      return true;  // Menandakan bahwa pop boleh terjadi
    }

    Future<void> _uploadFileWithLoading(
        BuildContext context,
        String filePath,
        int dokumenId,
        TugasAkhirItem item) async {
      // Store the scaffold context
      final scaffoldContext = context;
      BuildContext? dialogContext;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;  // Store dialog context
          return WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Expanded(child: Text("Mengunggah file...")),
                ],
              ),
            ),
          );
        },
      );

      try {
        // Proses unggah file
        await _uploadController.uploadFile(filePath, dokumenId, scaffoldContext);

        // Perbarui status item setelah berhasil
        if (mounted) {
          setState(() {
            item.status = 'Menunggu Divalidasi';
            item.isUploaded = true;
          });
        }

        // Close dialog using stored dialogContext
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
        }

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(content: Text('File berhasil diunggah')),
          );
        }
      } catch (e) {
        // Close dialog using stored dialogContext
        if (dialogContext != null) {
          Navigator.of(dialogContext!).pop();
        }

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah file: $e')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      // Cek semua syarat diverifikasi
      bool allVerified = _controller.daftarTugas.every((item) => item.status == 'Diverifikasi');
      print(partner_valid);
      // Logika untuk menampilkan tombol
      bool showDaftarSidangButton = false;
      if (partner == null) {
        // Jika patner null, cukup cek allVerified dan dataSidang
        showDaftarSidangButton = allVerified && dataSidang == null && _controller.daftarTugas.isNotEmpty;
      } else {
        // Jika patner tidak null, cek nilai patner_valid
        showDaftarSidangButton = allVerified && partner_valid == 1 && dataSidang == null && _controller.daftarTugas.isNotEmpty;
      }

      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(250, 250, 250, 250),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: const Color.fromARGB(250, 250, 250, 250),
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                            GoRouter.of(context).pushReplacement('/home_mahasiswa');
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Container(
                          width: 150,
                          child: Text(
                            userName ?? "Loading...",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.person, size: 30, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ..._controller.daftarTugas
                          .map((item) => buildTugasAkhirItem(item)),
                    ],
                  ),
                ),
                if (showDaftarSidangButton)
                  ElevatedButton(
                    onPressed: () async {
                      if (dataSidang == null) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarTaInput(),
                          ),
                        );
                        if (result == true) {
                          final token = Provider.of<AuthProvider>(context, listen: false).token;
                          if (token != null) {
                            loadMahasiswaData(token); // Muat ulang data
                          }
                        }
                      } else {
                        controller.checkSyarat(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Daftar Sidang'),
                  ),
                if(!showDaftarSidangButton && partner != null && partner_valid == 0)
                  Container(
                    color: Colors.yellow[700],
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.black),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'PERHATIAN: Anda belum bisa mendaftar sidang. Anggota harus melengkapi syarat terlebih dahulu.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!allVerified)
                  Container(
                    color: Colors.yellow[700],
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.black),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'PERHATIAN: Anda belum bisa mendaftar sidang. Semua syarat wajib diverifikasi terlebih dahulu.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }


    Widget buildTugasAkhirItem(TugasAkhirItem item) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        color: Colors.white, // Ubah warna Card menjadi putih
        child: ListTile(
          title: Text(item.namaDokumen),
          subtitle: Text(item.status),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isUploaded || item.status == 'Menunggu Divalidasi')
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      print("${item.namaDokumen} clicked!");
                    });
                    final int dokumenId = item.dokumen_id;
                    print('${Config.baseUrl}daftar-tugas-akhir/$dokumenId');
                    final String pdfUrl = '${Config.baseUrl}daftar-tugas-akhir/$dokumenId';
                    final String fileName = item.namaDokumen?.split('/').last ?? 'document.pdf';

                    if (item.isUploaded) {
                      final String safeFileName = truncateFileName(fileName, maxLength: 50);
                      downloadAndOpenPdf(context, pdfUrl, safeFileName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File tidak tersedia')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Ubah bentuk tombol menjadi kotak dengan edge
                    ),
                  ),
                  child: Text('Lihat'),
                ),
              if (item.isUploaded || item.status == 'Menunggu Divalidasi')
                SizedBox(width: 8),
              if (item.isUploaded && item.status == 'Menunggu Divalidasi')
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null && result.files.single.path != null) {
                      final filePath = result.files.single.path!;
                      await _uploadFileWithLoading(context, filePath, item.dokumen_id, item);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tidak ada file yang dipilih.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              if (!item.isUploaded && item.status == 'Belum Upload')
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null && result.files.single.path != null) {
                      final filePath = result.files.single.path!;
                      await _uploadFileWithLoading(context, filePath, item.dokumen_id, item);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tidak ada file yang dipilih.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Upload'),
                ),
            ],
          ),
          leading: CircleAvatar(
            backgroundColor: item.getColorIndicator(),
            radius: 8,
          ),
        ),
      );
    }
  }

  class PdfViewerScreen extends StatelessWidget {
    final String pdfPath;

    const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      print("PDF path to display: $pdfPath");
      return Scaffold(
        appBar: AppBar(
          title: const Text("PDF Viewer"),
        ),
        body: PDFView(
          filePath: pdfPath,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: true,
          pageFling: true,
        ),
      );
    }
  }
