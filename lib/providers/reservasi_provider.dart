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

  // 🔹 Update Logic: Reset data bawahannya jika Poli berubah
  void setSelectedPoli(MasterPoliModel? poli) {
    _selectedPoli = poli;
    _selectedDokter = null; // Reset dokter terpilih
    _dokterList = [];       // Reset list dokter
    _jadwalList = [];       // Reset jadwal
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

  // 3. Fetch Jadwal (DIPERBAIKI ✅)
  // Menyesuaikan dengan parameter Service baru
  Future<void> fetchJadwal({
    required String kodePoli, 
    String? kodeDokter, 
    String? tanggalReservasi,
  }) async {
    _isLoadingJadwal = true;
    _jadwalList = []; // Bersihkan dulu sebelum load baru
    notifyListeners();
    
    try {
      // Panggil service dengan Named Parameters
      _jadwalList = await _reservasiService.getJadwal(
        kodePoli: kodePoli,
        kodeDokter: kodeDokter,
        tanggalReservasi: tanggalReservasi,
      );
      _errorMessage = null;
    } catch (e) {
      _jadwalList = [];
      _errorMessage = 'Gagal memuat jadwal dokter';
      if (kDebugMode) print('fetchJadwal Error: $e');
    }
    
    _isLoadingJadwal = false;
    notifyListeners();
  }

  // 4. Buat Reservasi (DIPERBAIKI ✅)
  // Mengembalikan Map? agar UI bisa dapat data booking (no_pemeriksaan)
  Future<Map<String, dynamic>?> buatReservasi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Return value dari service sekarang adalah Map?
      final result = await _reservasiService.createReservasi(data);
      _errorMessage = null;
      return result;
    } catch (e) {
      _errorMessage = 'Gagal membuat reservasi';
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
      _errorMessage = 'Gagal memuat riwayat reservasi';
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
      _errorMessage = 'Gagal update pembayaran';
      if (kDebugMode) print('updatePembayaran Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
}