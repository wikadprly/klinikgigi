import 'package:flutter/foundation.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';
import 'package:flutter_klinik_gigi/core/services/reservasi_service.dart';

class ReservasiProvider extends ChangeNotifier {
  final ReservasiService _reservasiService = ReservasiService();

  // State Variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingJadwal = false;
  bool get isLoadingJadwal => _isLoadingJadwal;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MasterPoliModel> _poliList = [];
  List<MasterDokterModel> _dokterList = [];
  List<MasterJadwalModel> _jadwalList = [];
  List<ReservasiModel> _riwayatList = [];

  // Getters
  List<MasterPoliModel> get poliList => _poliList;
  List<MasterDokterModel> get dokterList => _dokterList;
  List<MasterJadwalModel> get jadwalList => _jadwalList;
  List<ReservasiModel> get riwayatList => _riwayatList;

  // Selection State
  MasterPoliModel? _selectedPoli;
  MasterDokterModel? _selectedDokter;

  MasterPoliModel? get selectedPoli => _selectedPoli;
  MasterDokterModel? get selectedDokter => _selectedDokter;

  String keluhan = "";

  void setKeluhan(String value) {
    keluhan = value;
    notifyListeners();
  }

  // Update Logic: Reset data bawahannya jika Poli berubah
  void setSelectedPoli(MasterPoliModel? poli) {
    _selectedPoli = poli;
    _selectedDokter = null; // Reset dokter terpilih
    _dokterList = []; // Reset list dokter
    _jadwalList = []; // Reset jadwal
    notifyListeners();
  }

  void setSelectedDokter(MasterDokterModel? dokter) {
    _selectedDokter = dokter;
    notifyListeners();
  }

  // 1. Fetch Daftar Poli
  Future<void> fetchPoli() async {
    _isLoading = true;
    notifyListeners();
    try {
      _poliList = await _reservasiService.getDaftarPoli();
      _errorMessage = null;
    } catch (e) {
      _poliList = [];
      _errorMessage = 'Gagal memuat daftar poli';
      if (kDebugMode) print('fetchPoli Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // 2. Fetch Dokter by Poli
  Future<void> fetchDokterByPoli(String kodePoli) async {
    _isLoading = true;
    notifyListeners();
    try {
      _dokterList = await _reservasiService.getDokterByPoli(kodePoli);
      _errorMessage = null;
    } catch (e) {
      _dokterList = [];
      _errorMessage = 'Gagal memuat daftar dokter';
      if (kDebugMode) print('fetchDokterByPoli Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // 3. Fetch Jadwal
  Future<void> fetchJadwal({
    required String kodePoli,
    String? kodeDokter,
    String? tanggalReservasi,
  }) async {
    _isLoadingJadwal = true;
    _jadwalList = [];
    notifyListeners();

    try {
      _jadwalList = await _reservasiService.getJadwal(
        kodePoli: kodePoli,
        kodeDokter: kodeDokter,
        tanggalReservasi: tanggalReservasi,
      );

      // Validasi hasil jadwal
      if (_jadwalList.isEmpty && tanggalReservasi != null) {
        _errorMessage = 'Tidak ada jadwal tersedia untuk tanggal yang dipilih';
      } else if (_jadwalList.isEmpty && kodeDokter != null) {
        _errorMessage = 'Tidak ada jadwal tersedia untuk dokter yang dipilih';
      } else if (_jadwalList.isEmpty) {
        _errorMessage = 'Tidak ada jadwal tersedia untuk kriteria yang dipilih';
      } else {
        _errorMessage = null;
      }
    } catch (e) {
      _jadwalList = [];
      _errorMessage = 'Gagal memuat jadwal dokter. Silakan coba lagi.';
      if (kDebugMode) print('fetchJadwal Error: $e');
    }

    _isLoadingJadwal = false;
    notifyListeners();
  }

  // 4. Buat Reservasi
  Future<Map<String, dynamic>?> buatReservasi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _reservasiService.createReservasi(data);
      _errorMessage = null;
      return result;
    } catch (e) {
      _errorMessage = 'Gagal membuat reservasi. Silakan coba lagi.';
      if (kDebugMode) print('buatReservasi Error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5. Riwayat Reservasi
  Future<void> fetchRiwayat(String rekamMedisId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _riwayatList = await _reservasiService.getRiwayatReservasi(rekamMedisId);
      _errorMessage = null;
    } catch (e) {
      _riwayatList = [];
      _errorMessage = 'Gagal memuat riwayat reservasi. Silakan coba lagi.';
      if (kDebugMode) print('fetchRiwayat Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // 6. Update Pembayaran
  Future<bool> updatePembayaran(
    String noPemeriksaan,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _reservasiService.updatePembayaran(
        noPemeriksaan,
        data,
      );
      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = 'Gagal update pembayaran. Silakan coba lagi.';
      if (kDebugMode) print('updatePembayaran Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 7. Create Reservasi with Payment
  Future<Map<String, dynamic>?> createReservasiWithPayment(
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _reservasiService.createReservasiWithPayment(data);
      _errorMessage = null;
      return result;
    } catch (e) {
      _errorMessage = 'Gagal membuat reservasi dengan pembayaran. Silakan coba lagi.';
      if (kDebugMode) print('createReservasiWithPayment Error: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 8. Check Payment Status
  Future<Map<String, dynamic>?> checkPaymentStatus(String noPemeriksaan) async {
    try {
      return await _reservasiService.checkPaymentStatus(noPemeriksaan);
    } catch (e) {
      if (kDebugMode) print('checkPaymentStatus Error: $e');
      return null;
    }
  }

  // 9. Fetch Tanggal Dengan Jadwal (FIXED RETURN TYPE)
  // Sekarang mengembalikan List<Map> agar UI bisa render nama hari dan tanggal
  Future<List<Map<String, dynamic>>> fetchTanggalDenganJadwal({
    String? kodePoli,
    String? kodeDokter,
  }) async {
    try {
      final result = await _reservasiService.getTanggalDenganJadwal(
        kodePoli: kodePoli,
        kodeDokter: kodeDokter,
      );

      // Validasi hasil tanggal
      if (result.isEmpty && kodePoli != null && kodeDokter != null) {
        _errorMessage = 'Tidak ada tanggal dengan jadwal untuk poli dan dokter yang dipilih';
      } else if (result.isEmpty && kodePoli != null) {
        _errorMessage = 'Tidak ada tanggal dengan jadwal untuk poli yang dipilih';
      } else if (result.isEmpty && kodeDokter != null) {
        _errorMessage = 'Tidak ada tanggal dengan jadwal untuk dokter yang dipilih';
      } else {
        _errorMessage = null;
      }

      return result;
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar tanggal. Silakan coba lagi.';
      if (kDebugMode) print('fetchTanggalDenganJadwal Error: $e');
      return [];
    }
  }

  // 10. Fetch Dokter Dengan Jadwal (FIXED RETURN TYPE)
  // Sekarang mengembalikan List<Map> agar UI bisa render nama dokter + sisa kuota
  Future<List<Map<String, dynamic>>> fetchDokterDenganJadwal({
    required String kodePoli,
    required String tanggalReservasi,
  }) async {
    try {
      final result = await _reservasiService.getDokterDenganJadwal(
        kodePoli: kodePoli,
        tanggalReservasi: tanggalReservasi,
      );

      // Validasi hasil dokter
      if (result.isEmpty) {
        _errorMessage = 'Tidak ada dokter dengan jadwal pada tanggal yang dipilih';
      } else {
        _errorMessage = null;
      }

      return result;
    } catch (e) {
      _errorMessage = 'Gagal memuat daftar dokter. Silakan coba lagi.';
      if (kDebugMode) print('fetchDokterDenganJadwal Error: $e');
      return [];
    }
  }

  void clearData() {
    _poliList = [];
    _dokterList = [];
    _jadwalList = [];
    _riwayatList = [];
    _selectedPoli = null;
    _selectedDokter = null;
    keluhan = "";
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Method untuk validasi input sebelum fetch data
  bool validateInput({
    String? kodePoli,
    String? kodeDokter,
    String? tanggalReservasi,
  }) {
    if (kodePoli == null || kodePoli.isEmpty) {
      _errorMessage = 'Silakan pilih poli terlebih dahulu';
      notifyListeners();
      return false;
    }

    // Tidak wajibkan dokter dan tanggal karena bisa menampilkan semua
    return true;
  }

  // Get reservation fee from settings
  Future<int> getReservationFee() async {
    try {
      return await _reservasiService.getReservationFee();
    } catch (e) {
      if (kDebugMode) print('getReservationFee Error: $e');
      return 25000; // Default value if API call fails
    }
  }
}