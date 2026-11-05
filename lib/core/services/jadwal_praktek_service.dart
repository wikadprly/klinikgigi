import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/config/api.dart'; // Sesuaikan jika API ada di lokasi lain
import 'package:flutter_klinik_gigi/config/app_config.dart';
import 'package:flutter_klinik_gigi/core/models/dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/jadwal_praktek_model.dart';

class JadwalPraktekService {
  Future<List<DokterModel>> getJadwalPraktek() async {
    if (AppConfig.demoMode) {
      return [
        DokterModel(
          id: 1,
          namaDokter: 'Bagus Pratama',
          spesialisasi: 'Dokter Gigi Umum',
          jadwal: [
            JadwalPraktek(
              hari: 'Senin',
              jamMulai: '09:00',
              jamSelesai: '12:00',
            ),
            JadwalPraktek(
              hari: 'Rabu',
              jamMulai: '09:00',
              jamSelesai: '12:00',
            ),
          ],
        ),
        DokterModel(
          id: 2,
          namaDokter: 'Ayu Lestari',
          spesialisasi: 'Dokter Gigi Umum',
          jadwal: [
            JadwalPraktek(
              hari: 'Selasa',
              jamMulai: '13:00',
              jamSelesai: '16:00',
            ),
            JadwalPraktek(
              hari: 'Kamis',
              jamMulai: '13:00',
              jamSelesai: '16:00',
            ),
          ],
        ),
        DokterModel(
          id: 3,
          namaDokter: 'Citra Dewi, Sp.Ort',
          spesialisasi: 'Ortodonti',
          jadwal: [
            JadwalPraktek(
              hari: 'Rabu',
              jamMulai: '10:00',
              jamSelesai: '14:00',
            ),
          ],
        ),
        DokterModel(
          id: 4,
          namaDokter: 'Dimas Saputra, Sp.BM',
          spesialisasi: 'Bedah Mulut',
          jadwal: [
            JadwalPraktek(
              hari: 'Jumat',
              jamMulai: '08:00',
              jamSelesai: '11:00',
            ),
          ],
        ),
      ];
    }

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
