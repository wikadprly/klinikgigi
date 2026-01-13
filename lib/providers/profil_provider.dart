import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/profil_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class ProfileProvider with ChangeNotifier {
  final ProfilService _profilService = ProfilService();

  Map<String, dynamic>? user;
  Map<String, dynamic>? rekamMedis;
  String? _namaAsuransi;
  String? _noPeserta;
  String? _statusAktif;

  // =====================
  // FOTO PROFIL (FIXED)
  // =====================
  String? _photoUrl;
  String? get photoUrl => _photoUrl;

  bool isLoading = false;

  // =====================
  // Ambil profil user
  // =====================
  Future<void> fetchProfile(String token) async {
    isLoading = true;
    notifyListeners();

    final result = await _profilService.getProfil(token);
    if (result["success"] == true) {
      user = result["data"]["user"];
      rekamMedis = result["data"]["rekam_medis"];
      _namaAsuransi = result["data"]["nama_asuransi"]?.toString();
      _noPeserta = result["data"]["no_peserta"]?.toString();
      _statusAktif = result["data"]["status_aktif"]?.toString();
    }

    // 🔥 AMBIL FOTO DARI ENDPOINT KHUSUS
    await fetchProfilePhoto(token);

    isLoading = false;
    notifyListeners();
  }

  // =====================
  // GET FOTO PROFIL (BARU)
  // =====================
  Future<void> fetchProfilePhoto(String token) async {
    final result = await _profilService.getProfilePhoto(token);

    if (result != null && result["success"] == true) {
      _photoUrl = result["url"];
    } else {
      _photoUrl = null;
    }

    notifyListeners();
  }

  // =====================
  // Update data profil (tanpa foto)
  // =====================
  Future<bool> updateProfil(String token, Map<String, dynamic> data) async {
    final result = await _profilService.updateProfil(token, data);
    if (result["success"] == true) {
      await fetchProfile(token);
      return true;
    }
    return false;
  }

  // =====================
  // Upload / Ganti foto profil
  // =====================
  Future<bool> updateProfilePicture(File file) async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null) return false;

    final result = await _profilService.updateProfilePicture(token, file);

    // 🔥 setelah upload, refresh FOTO SAJA
    if (result["success"] == true || result["status"] == "ok") {
      await fetchProfilePhoto(token);
      return true;
    }
    return false;
  }

  // =====================
  // Hapus foto profil
  // =====================
  Future<bool> removeProfilePicture() async {
    final token = await SharedPrefsHelper.getToken();
    if (token == null) return false;

    final result = await _profilService.deleteProfilePicture(token);
    if (result["success"] == true) {
      await fetchProfilePhoto(token);
      return true;
    }
    return false;
  }

  // =====================
  // Helpers / Computed Getters for Home Screen
  // =====================
  String get namaPengguna =>
      user?['nama_pengguna'] ?? user?['nama'] ?? 'Pengguna';

  String get noRekamMedis {
    if (rekamMedis != null) {
      return rekamMedis?['rekam_medis'] ??
          rekamMedis?['id_rekam_medis'] ??
          rekamMedis?['no_rekam_medis'] ??
          rekamMedis?['nomor'] ??
          '-';
    }
    return user?['rekam_medis_id'] ?? '-';
  }

  String get genderLabel {
    final g = user?['jenis_kelamin']?.toString().toLowerCase();
    if (g == null) return '-';
    if (g.contains('l') || g.contains('pria')) return 'Pria';
    if (g.contains('p') || g.contains('wanita') || g.contains('perempuan'))
      return 'Wanita';
    return g;
  }

  int get umur {
    final tglArg = user?['tanggal_lahir']?.toString();
    if (tglArg == null || tglArg.isEmpty) return 0;

    try {
      // Format backend bisa jadi "1990-01-01" atau "1990-01-01 00:00:00"
      // Ambil bagian tanggal saja agar aman
      final cleanDateStr = tglArg.split(' ').first; // "1990-01-01"
      final birthDate = DateTime.parse(cleanDateStr);
      final now = DateTime.now();

      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      debugPrint("Error parsing umur: $e");
      return 0;
    }
  }
}

// ============================================================
// COMPATIBILITY SHIM (TIDAK DIUBAH)
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

  String? get namaAsuransi => _namaAsuransi;
  String? get noPeserta => _noPeserta;
  String? get statusAktif => _statusAktif;

  String? get errorMessage => null;
}
