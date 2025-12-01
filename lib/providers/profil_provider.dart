import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/services/profil_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'dart:io';

class ProfilProvider with ChangeNotifier {
  final ProfilService _service = ProfilService();

  Map<String, dynamic>? profilData;
  bool isLoading = false;
  String? errorMessage;

  // Getter untuk data user
  Map<String, dynamic>? get userData => profilData?["data"]?["user"];

  // Getter untuk data rekam medis
  Map<String, dynamic>? get rekamMedisData =>
      profilData?["data"]?["rekam_medis"];

  // Getter untuk informasi asuransi
  String? get namaAsuransi => profilData?["data"]?["nama_asuransi"];
  String? get noPeserta => profilData?["data"]?["no_peserta"];
  String? get statusAktif => profilData?["data"]?["status_aktif"];

  Future<void> fetchProfil(String token) async {
    try {
      print(
        "ProfilProvider: Starting to fetch profile with token: ${token.length > 0 ? '***' : 'empty'}",
      );
      isLoading = true;
      notifyListeners();

      final result = await _service.getProfil(token);
      print("ProfilProvider: Raw API response: $result");

      if (result["success"] == true) {
        profilData = result;
        errorMessage = null;
        print("ProfilProvider: Profile data set successfully");
        print("ProfilProvider: User data: ${profilData?["data"]?["user"]}");
      } else {
        errorMessage = result["message"] ?? "Gagal mengambil profil";
        print("ProfilProvider: API returned error: $errorMessage");
      }
    } catch (e) {
      errorMessage = e.toString();
      print("ProfilProvider: Error fetching profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfilFromToken() async {
    String? token = await SharedPrefsHelper.getToken();
    print(
      "ProfilProvider: Token from SharedPrefsHelper: ${token != null && token.isNotEmpty ? '***' : 'null/empty'}",
    );

    if (token != null && token.isNotEmpty) {
      await fetchProfil(token);
    } else {
      errorMessage = "Token tidak ditemukan";
      print("ProfilProvider: No token available to fetch profile");
    }
  }

  Future<bool> updateProfil(String token, Map<String, dynamic> data) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _service.updateProfil(token, data);

      if (result["success"] == true) {
        await fetchProfil(token);
        return true;
      }

      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfilePicture(File imageFile) async {
    try {
      isLoading = true;
      notifyListeners();

      String? token = await SharedPrefsHelper.getToken();
      if (token == null) {
        errorMessage = "Token tidak ditemukan";
        return false;
      }

      final result = await _service.updateProfilePicture(token, imageFile);

      if (result["success"] == true) {
        await fetchProfil(token);
        return true;
      }

      errorMessage = result["message"] ?? "Gagal mengupdate foto profil";
      return false;
    } catch (e) {
      errorMessage = e.toString();
      print("Error updating profile picture: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeProfilePicture() async {
    try {
      isLoading = true;
      notifyListeners();

      String? token = await SharedPrefsHelper.getToken();
      if (token == null) {
        errorMessage = "Token tidak ditemukan";
        return false;
      }

      final result = await _service.deleteProfilePicture(token);

      if (result["success"] == true) {
        await fetchProfil(token);
        return true;
      }

      errorMessage = result["message"] ?? "Gagal menghapus foto profil";
      return false;
    } catch (e) {
      errorMessage = e.toString();
      print("Error removing profile picture: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
