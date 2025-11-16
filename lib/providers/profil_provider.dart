import 'package:flutter/material.dart';
import '../core/services/profil_service.dart';

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
