import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/profil_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class ProfileProvider with ChangeNotifier {
  final ProfilService _profilService = ProfilService();

  Map<String, dynamic>? user;
  Map<String, dynamic>? rekamMedis;
  bool isLoading = false;

  // Ambil profil user
  Future<void> fetchProfile(String token) async {
    isLoading = true;
    notifyListeners();

    final result = await _profilService.getProfil(token);

    if (result["success"] == true) {
      user = result["data"]["user"];
      rekamMedis = result["data"]["rekam_medis"];
    }

    isLoading = false;
    notifyListeners();
  }

  // Update profil
  Future<bool> updateProfil(String token, Map<String, dynamic> data) async {
    final result = await _profilService.updateProfil(token, data);

    if (result["success"] == true) {
      await fetchProfile(token); // refresh data
      return true;
    }

    return false;
  }
}

// Compatibility shim: many parts of the app reference `ProfilProvider` (no 'e')
// and expect a slightly different API (e.g. fetchProfil, userData, profilData).
// Provide a thin adapter to avoid widespread refactors.

class ProfilProvider extends ProfileProvider {
  Future<void> fetchProfil(String token) => fetchProfile(token);

  /// Ambil token dari SharedPrefs dan panggil fetchProfil
  Future<void> fetchProfilFromToken() async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      await fetchProfil(token);
    }
  }

  Map<String, dynamic>? get userData => user;
  Map<String, dynamic>? get profilData => user;
  Map<String, dynamic>? get rekamMedisData => rekamMedis;

  // Optional fields used in UI; provide null defaults.
  String? get namaAsuransi => null;
  String? get noPeserta => null;
  String? get statusAktif => null;

  String? get errorMessage => null;

  // Stubs for image upload/remove used by UI. Implement real logic later.
  Future<bool> updateProfilePicture(File file) async {
    // Not implemented: return false so UI shows failure message.
    return false;
  }

  Future<bool> removeProfilePicture() async {
    return false;
  }
}
