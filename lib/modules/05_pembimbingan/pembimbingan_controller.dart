class PembimbinganController {
  // Simulasi pengambilan data pembimbing dari database
  Future<bool> checkIfDataPlotted() async {
    // Implementasikan pengambilan data dari database
    await Future.delayed(const Duration(seconds: 1));
    // Ubah false menjadi true ketika data pembimbing ada di database
    return false; // Contoh awal, belum ada data
  }
}
