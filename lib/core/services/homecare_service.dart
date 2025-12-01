import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';
import '../storage/shared_prefs_helper.dart';

class HomeCareService {
  final String _url = ApiEndpoint.homecareJadwal;

  /// Ambil daftar master jadwal dari server dan filter berdasarkan tanggal
  /// Mengembalikan list map dengan keys: name, time, quota, master_jadwal_id
  Future<List<Map<String, String>>> fetchJadwalForDate(DateTime date) async {
    try {
      final uri = Uri.parse(_url).replace(
        queryParameters: {'tanggal': date.toIso8601String().split('T')[0]},
      );

      final token = await SharedPrefsHelper.getToken();
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];
        if (data is List) {
            final List<Map<String, String>> result = [];

          for (final item in data) {
            try {
              // item expected to contain fields: hari, jam_mulai, jam_selesai, quota, remaining_quota, dokter
              final hari = item['hari']?.toString() ?? '';

              final dokter = item['dokter'] ?? {};
              final dokterNama = (dokter['nama'] ?? '') as String;
              final dokterGelar = (dokter['gelar'] ?? '') as String;
              final name = (dokterNama + (dokterGelar.isNotEmpty ? ', ' + dokterGelar : '')).trim();

              final jamMulai = item['jam_mulai']?.toString() ?? '';
              final jamSelesai = item['jam_selesai']?.toString() ?? '';
              final time = '${hari.isNotEmpty ? hari : ''} | ${jamMulai}${jamMulai.isNotEmpty && jamSelesai.isNotEmpty ? '–' + jamSelesai : ''}';

              final remaining = item['remaining_quota']?.toString() ?? item['quota']?.toString() ?? '';
              final id = item['id']?.toString() ?? item['master_jadwal_id']?.toString() ?? '';

              result.add({
                'name': name.isNotEmpty ? name : 'Dokter',
                'time': time,
                'quota': remaining.isNotEmpty ? '0/${remaining}' : '0',
                'master_jadwal_id': id,
              });
            } catch (e) {
              // skip malformed item
              continue;
            }
          }

          return result;
        } else {
          throw Exception('Response data is not a list');
        }
      } else {
        throw Exception('Failed to fetch jadwal. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil jadwal homecare: ${e.toString()}');
    }
  }
}
