import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/services/profil_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class ProfileProvider with ChangeNotifier {
  final ProfilService _profilService = ProfilService();

  Map<String, dynamic>? user;
  Map<String, dynamic>? rekamMedis;
  String? _namaAsuransi;
  String? _noPeserta;
  String? _statusAktif;
  bool isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // =====================
  // Ambil profil user
  // =====================
  Future<void> fetchProfile(String token) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _profilService.getProfil(token);
      if (result["success"] == true) {
        final data = result["data"];
        user = data["user"];
        rekamMedis = data["rekam_medis"];
        _namaAsuransi = data["nama_asuransi"]?.toString();
        _noPeserta = data["no_peserta"]?.toString();
        _statusAktif = data["status_aktif"]?.toString();
      } else {
        _errorMessage = result["message"]?.toString() ?? "Gagal memuat profil";
      }
    } catch (e) {
      _errorMessage = "Gagal memuat profil: $e";
      debugPrint("fetchProfile error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // Update data profil (tanpa foto)
  // =====================
  Future<bool> updateProfil(String token, Map<String, dynamic> data) async {
    try {
      final result = await _profilService.updateProfil(token, data);
      if (result["success"] == true) {
        await fetchProfile(token);
        return true;
      }
      _errorMessage = result["message"]?.toString() ?? "Gagal update profil";
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Gagal update profil: $e";
      notifyListeners();
      return false;
    }
  }

  // =====================
  // Upload / Ganti foto profil
  // =====================
  Future<bool> updateProfilePicture(XFile file) async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null) {
      _errorMessage = "Sesi tidak ditemukan, silakan login ulang";
      notifyListeners();
      return false;
    }

    try {
      final result = await _profilService.updateProfilePicture(token, file);
      if (result["success"] == true) {
        await fetchProfile(token);
        return true;
      }
      _errorMessage = result["message"]?.toString() ?? "Gagal mengunggah foto";
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Gagal mengunggah foto: $e";
      notifyListeners();
      return false;
    }
  }

  // =====================
  // Hapus foto profil
  // =====================
  Future<bool> removeProfilePicture() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null) {
      _errorMessage = "Sesi tidak ditemukan, silakan login ulang";
      notifyListeners();
      return false;
    }

    try {
      final result = await _profilService.deleteProfilePicture(token);
      if (result["success"] == true) {
        await fetchProfile(token);
        return true;
      }
      _errorMessage = result["message"]?.toString() ?? "Gagal menghapus foto";
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Gagal menghapus foto: $e";
      notifyListeners();
      return false;
    }
  }
}

// ============================================================
// COMPATIBILITY SHIM (biar file2 lama yg pakai nama ProfilProvider tetep jalan)
// ============================================================
class ProfilProvider extends ProfileProvider {
  Future<void> fetchProfil(String token) => fetchProfile(token);

  Future<void> fetchProfilFromToken() async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      await fetchProfile(token);
    }
  }

  Map<String, dynamic>? get userData => user;
  Map<String, dynamic>? get profilData => user;
  Map<String, dynamic>? get rekamMedisData => rekamMedis;

  String? get namaAsuransiValue => _namaAsuransi;
  String? get noPesertaValue => _noPeserta;
  String? get statusAktifValue => _statusAktif;

  String? get namaAsuransi => _namaAsuransi;
  String? get noPeserta => _noPeserta;
  String? get statusAktif => _statusAktif;
}
