import 'package:flutter/foundation.dart';
import '../core/models/biaya_layanan_model.dart';
import '../core/services/biaya_layanan_service.dart';

class BiayaLayananProvider with ChangeNotifier {
  final BiayaLayananService _service = BiayaLayananService();

  BiayaLayananModel? _currentBiayaLayanan;
  bool _isLoading = false;
  String? _errorMessage;

  BiayaLayananModel? get currentBiayaLayanan => _currentBiayaLayanan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Mengambil biaya layanan berdasarkan tipe layanan dan jenis pasien
  Future<BiayaLayananModel?> fetchBiayaLayanan({
    required String tipeLayanan,
    required String jenisPasien,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.getBiayaLayanan(
        tipeLayanan: tipeLayanan,
        jenisPasien: jenisPasien,
      );

      if (result != null) {
        _currentBiayaLayanan = BiayaLayananModel.fromJson(result);
        _errorMessage = null;
        notifyListeners();
        return _currentBiayaLayanan;
      } else {
        _errorMessage = 'Biaya layanan tidak ditemukan';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Gagal mengambil biaya layanan: $e';
      if (kDebugMode) print('Error fetchBiayaLayanan: $_errorMessage');
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Getter untuk biaya reservasi
  int get currentBiayaReservasi {
    return _currentBiayaLayanan?.biayaReservasi ?? 0;
  }

  /// Reset data
  void resetData() {
    _currentBiayaLayanan = null;
    _errorMessage = null;
    notifyListeners();
  }
}
