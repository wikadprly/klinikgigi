import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import '../models/pasien_model.dart';
import '../../config/api.dart';

class PasienService {
  // FUNGSI BARU: Untuk mengambil data pasien yang sedang login
  Future<Pasien> getPasienLogin() async {
    // 3. UBAH LOGIKA PENGAMBILAN TOKEN
    // Ambil data user lengkap dari SharedPreferences menggunakan helper
    final UserModel? user = await SharedPrefsHelper.getUser();

    // Cek apakah user ada dan punya token
    // (Asumsi: UserModel Anda memiliki properti 'token')
    if (user == null || user.token == null || user.token!.isEmpty) {
      throw Exception('Token tidak ditemukan. Harap login kembali.');
    }

    // Ambil token dari UserModel
    final String token = user.token!;

    // menentukan URL (sesuai routes/api.php)
    final url = Uri.parse('${ApiConfig.baseUrl}/pasien');

    // 4. SISA KODE SAMA PERSIS (sudah benar)
    // membuat request DENGAN authorization header
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    // Proses response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // mengecek apakah API bisa mengembalikan data sukses
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        // mengambil data dari payload
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          // model Pasien (pasien_model.dart) harus sesuai
          // dengan data yang dikembalikan (yaitu dari tabel 'users' berdasarkan MpUser.php)
          return Pasien.fromJson(payload);
        }
      }

      // mengecek jika API mengembalikan error
      if (data is Map<String, dynamic> && data['status'] == 'error') {
        throw Exception(data['message'] ?? 'Gagal memuat data pasien.');
      }

      // Jika format tidak terduga
      throw FormatException('Format respon tidak terduga dari server.');
    } else if (response.statusCode == 404) {
      // Error 404 dari PasienController@index
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Data pasien tidak ditemukan (404).');
    } else if (response.statusCode == 401) {
      // Token tidak valid atau expired
      throw Exception('Autentikasi gagal. Silakan login ulang (401).');
    } else {
      // Error server lainnya
      throw Exception(
        'Gagal memuat data pasien. Status Code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }
}
