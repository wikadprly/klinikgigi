import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/services/profil_service.dart';

class ProfilProvider with ChangeNotifier {
  final ProfilService _service = ProfilService();

  Map<String, dynamic>? profilData;
  bool isLoading = false;
  String? errorMessage;

  // Getter untuk data user
  Map<String, dynamic>? get userData => profilData?["data"]?["user"];

  // Getter untuk data rekam medis
  Map<String, dynamic>? get rekamMedisData => profilData?["data"]?["rekam_medis"];

  // Getter untuk informasi asuransi
  String? get namaAsuransi => profilData?["data"]?["nama_asuransi"];
  String? get noPeserta => profilData?["data"]?["no_peserta"];
  String? get statusAktif => profilData?["data"]?["status_aktif"];

  Future<void> fetchProfil(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _service.getProfil(token);

      if (result["success"] == true) {
        profilData = result;
        errorMessage = null;
      } else {
        errorMessage = result["message"] ?? "Gagal mengambil profil";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
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
}
