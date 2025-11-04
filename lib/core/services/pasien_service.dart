// lib/services/pasien_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pasien_model.dart';
import '../../config/api_home.dart';

class PasienService {
  Future<Pasien> getPasienByUserId(String userId) async {
    // Menggunakan URL yang sudah diperbaiki (sesuai PasienService sebelumnya)
    final url = Uri.parse('${ApiConfig.baseUrl}/pasien/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 💡 Perbaikan: Cek jika body kosong atau hanya spasi sebelum mencoba decode.
      if (response.body.trim().isEmpty) {
        throw Exception(
          'Server mengembalikan Status Code 200 OK, tetapi body kosong (tidak ada data pasien).',
        );
      }

      try {
        final data = json.decode(response.body);

        // Jika API mengembalikan error logika dalam format JSON
        if (data is Map<String, dynamic> &&
            data.containsKey('status') &&
            data['status'] == 'error') {
          throw Exception(
            data['message'] ?? 'Gagal memuat data pasien dari API.',
          );
        }

        // Beberapa API membungkus payload di dalam kunci 'data', contoh:
        // { "status": "success", "data": { ... } }
        // Jadi kita unwrap jika perlu.
        dynamic payload = data;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          payload = data['data'];
        }

        // Pastikan payload adalah Map sebelum memanggil fromJson
        if (payload is Map<String, dynamic>) {
          return Pasien.fromJson(payload);
        }

        // Jika payload bukan Map, berikan pesan yang jelas untuk debugging
        throw FormatException(
          'Payload dari server tidak memiliki format yang diharapkan (Map). Body: "${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}..."',
        );
      } on FormatException catch (e) {
        // Tangani FormatException dan error JSON decoding lainnya
        // Menambahkan respons body ke pesan error untuk debugging di Flutter
        throw FormatException(
          'Gagal memproses data dari server. Respon bukan JSON valid. Body: "${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}..." Detail: $e',
        );
      } catch (e) {
        // Tangani error umum lainnya
        throw Exception(
          'Terjadi kesalahan tak terduga saat memproses data: $e',
        );
      }
    } else {
      // Tangani Status Code non-200 (seperti 404, 500, dll.)
      throw Exception(
        'Gagal memuat data pasien. Status Code: ${response.statusCode}',
      );
    }
  }
}
