// lib/core/services/pasien_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pasien_model.dart';
import '../storage/shared_prefs_helper.dart';

class PasienService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<Pasien> getPasienByUserId(String userId) async {
    // ✅ Ambil token dari SharedPrefs
    final token = await SharedPrefsHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login terlebih dahulu.');
    }

    // ✅ Gunakan endpoint protected /pasien
    final url = Uri.parse('$baseUrl/pasien');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // ✅ Kirim token
        'Accept': 'application/json',
      },
    );

    // ✅ Handle errors dengan pesan yang jelas (401, 500, dll)
    if (response.statusCode == 200) {
      if (response.body.trim().isEmpty) {
        throw Exception('Server mengembalikan status 200 tapi body kosong.');
      }

      try {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('status') &&
            data['status'] == 'error') {
          throw Exception(
            data['message'] ?? 'Gagal memuat data pasien dari API.',
          );
        }

        dynamic payload = data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          payload = data['data'];
        }

        if (payload is Map<String, dynamic>) {
          return Pasien.fromJson(payload);
        }

        throw Exception('Format payload tidak sesuai (bukan Map).');
      } catch (e) {
        throw Exception('Gagal memproses data: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception(
        'Token tidak valid atau sudah expired. Silakan login kembali.',
      );
    } else if (response.statusCode == 500) {
      throw Exception('Server error (500). Hubungi administrator.');
    } else {
      throw Exception(
        'Gagal memuat data pasien. Status Code: ${response.statusCode}',
      );
    }
  }
}
