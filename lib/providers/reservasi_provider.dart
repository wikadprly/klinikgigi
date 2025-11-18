import 'package:flutter/foundation.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';
import 'package:flutter_klinik_gigi/core/services/reservasi_service.dart';

class ReservasiProvider extends ChangeNotifier {
  final ReservasiService _reservasiService = ReservasiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

<<<<<<< HEAD
=======
  bool _isLoadingJadwal = false;
  bool get isLoadingJadwal => _isLoadingJadwal;

>>>>>>> 0470ff9 (refactor: improve reservasi provider logic)
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MasterPoliModel> _poliList = [];
  List<MasterDokterModel> _dokterList = [];
  List<MasterJadwalModel> _jadwalList = [];
  List<ReservasiModel> _riwayatList = [];

  List<MasterPoliModel> get poliList => _poliList;
  List<MasterDokterModel> get dokterList => _dokterList;
  List<MasterJadwalModel> get jadwalList => _jadwalList;
  List<ReservasiModel> get riwayatList => _riwayatList;

  String keluhan = "";

  void setKeluhan(String value) {
    keluhan = value;
    notifyListeners();
  }

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

<<<<<<< HEAD
  Future<void> fetchJadwal(String kodeDokter, String tanggal) async {
    _isLoading = true;
    notifyListeners();
    try {
      _jadwalList = await _reservasiService.getJadwal(kodeDokter, tanggal);
=======
  Future<void> fetchJadwal({
    required String kodeDokter,
    required String kodePoli,
    required String tanggalReservasi,
  }) async {
    _isLoadingJadwal = true;
    notifyListeners();
    try {
      _jadwalList = await _reservasiService.getJadwal(
        kodeDokter,
        tanggalReservasi,
      );
>>>>>>> 0470ff9 (refactor: improve reservasi provider logic)
      _errorMessage = null;
    } catch (e) {
      _jadwalList = [];
      _errorMessage = 'Gagal memuat jadwal dokter';
      if (kDebugMode) print('fetchJadwal Error: $e');
    }
<<<<<<< HEAD
    _isLoading = false;
=======
    _isLoadingJadwal = false;
>>>>>>> 0470ff9 (refactor: improve reservasi provider logic)
    notifyListeners();
  }

  Future<bool> buatReservasi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _reservasiService.createReservasi(data);
      _errorMessage = null;
      return success;
    } catch (e) {
      _errorMessage = 'Gagal membuat reservasi';
      if (kDebugMode) print('buatReservasi Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
