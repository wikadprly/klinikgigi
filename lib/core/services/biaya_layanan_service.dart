import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BiayaLayananService {
  static const String baseUrl = 'https://pbl250116.informatikapolines.id/api'; // Sesuaikan dengan URL backend Anda

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Mengambil biaya layanan berdasarkan tipe layanan dan jenis pasien
  Future<Map<String, dynamic>?> getBiayaLayanan({
    required String tipeLayanan,
    required String jenisPasien,
  }) async {
    final url = Uri.parse('$baseUrl/biaya-layanan/get-biaya');
    
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'tipe_layanan': tipeLayanan,
          'jenis_pasien': jenisPasien,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        } else {
          print("Gagal mengambil biaya: ${data['message']}");
          return null;
        }
      } else {
        print("Gagal menghubungi server: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error saat mengambil biaya: $e");
      return null;
    }
  }
}