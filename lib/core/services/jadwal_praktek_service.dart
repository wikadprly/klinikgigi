import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/config/api.dart'; // Sesuaikan jika API ada di lokasi lain
import 'package:flutter_klinik_gigi/core/models/dokter_model.dart';

class JadwalPraktekService {
  Future<List<DokterModel>> getJadwalPraktek() async {
    // Pastikan 'ApiEndpoint.jadwalPraktek' ada dan memberikan URL yang valid
    final url = Uri.parse(ApiEndpoint.jadwalPraktek);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Asumsi struktur JSON adalah {"data": [...]}
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('data') && data['data'] is List) {
          final List jadwalData = data['data'];
          return jadwalData.map((e) => DokterModel.fromJson(e)).toList();
        } else {
          // Kasus jika format JSON tidak sesuai harapan
          throw const FormatException("Format data server tidak valid.");
        }
      } else {
        // Tangani status code selain 200
        throw Exception(
          "Gagal mengambil data jadwal. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      // Tangani error jaringan atau decoding
      throw Exception("Terjadi error: $e");
    }
  }
}
