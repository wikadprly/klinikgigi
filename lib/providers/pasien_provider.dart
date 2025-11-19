import 'package:flutter/foundation.dart';
import '../core/models/pasien_model.dart';
import '../core/services/pasien_service.dart';

// PasienProvider bertugas sebagai lapisan manajemen state
class PasienProvider extends ChangeNotifier {
  // Inisiasi Service untuk komunikasi ke API
  final PasienService _pasienService = PasienService();

  Pasien? _pasien;
  Pasien? get pasien => _pasien; // Data pasien saat ini

  bool _isLoading = false;
  bool get isLoading => _isLoading; // Status pemuatan

  String? _errorMessage;
  String? get errorMessage => _errorMessage; // Pesan error jika terjadi

  // Method untuk mengambil data pasien berdasarkan ID pengguna
  Future<void> fetchPasienByUserId(String userId) async {
    // 1. Reset state dan atur loading menjadi true
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 2. Memanggil PasienService untuk mendapatkan data
      final fetchedPasien = await _pasienService.getPasienByUserId(userId);

      // 3. Update data pasien dan set loading menjadi false
      _pasien = fetchedPasien;
      _isLoading = false;
    } catch (e) {
      // 4. Tangani error dan set pesan error
      _pasien = null; // Kosongkan data pasien jika gagal

      String message;
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('ClientException')) {
        message =
            'Gagal terhubung ke server. Pastikan server Laravel aktif dan IP di api_home.dart benar.';
      } else if (e.toString().contains('Exception:')) {
        message = e.toString().replaceFirst(
          'Exception: ',
          '',
        ); // Ambil pesan error yang bersih
      } else {
        message = 'Terjadi kesalahan saat memuat data pasien.';
      }

      _errorMessage = message;
      _isLoading = false;

      // Kebutuhan debugging, bisa dihapus di production
      if (kDebugMode) {
        print('Pasien Provider Error: $_errorMessage');
      }
    } finally {
      // 5. Beri tahu widget bahwa state telah diperbarui
      notifyListeners();
    }
  }

  // Method lain (opsional) jika ingin menghapus data pasien saat logout
  void clearPasien() {
    _pasien = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
