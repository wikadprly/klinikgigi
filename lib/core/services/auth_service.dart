import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class AuthService {
  static const String baseUrl = 'https://pbl250116.informatikapolines.id/api';
  //ip sesuaikan kelen mau tes dimanaz, cek firewall mengijinkan port 8000

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Try to extract token from common response shapes and persist it
        try {
          String? token;
          if (data['token'] != null && data['token'] is String) {
            token = data['token'];
          } else if (data['access_token'] != null &&
              data['access_token'] is String) {
            token = data['access_token'];
          } else if (data['data'] != null && data['data'] is Map) {
            final d = data['data'];
            if (d['token'] != null && d['token'] is String) token = d['token'];
            if (d['access_token'] != null && d['access_token'] is String) {
              token = d['access_token'];
            }
          }

          if (token != null && token.isNotEmpty) {
            await SharedPrefsHelper.saveToken(token);
          }
        } catch (e) {
          print('Warning: gagal ekstrak token: $e');
        }

        if (data['data'] != null) {
          final user = UserModel.fromJson(data['data']);
          await SharedPrefsHelper.saveUser(user); // simpan user
          return {'success': true, 'user': user};
        }
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login gagal (${response.statusCode})',
      };
    } catch (e) {
      print('Error login: $e');
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String tipePasien,
    String? rekamMedisId,
    String? namaPengguna,
    String? nik,
    String? email,
    String? noHp,
    String? tanggalLahir,
    String? jenisKelamin,
    String? alamat,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tipe_pasien': tipePasien,
          'rekam_medis_id': rekamMedisId,
          'nama_pengguna': namaPengguna,
          'nik': nik,
          'email': email,
          'no_hp': noHp,
          'tanggal_lahir': tanggalLahir,
          'jenis_kelamin': jenisKelamin,
          'alamat': alamat,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print("Response register (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Registrasi berhasil'};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              data['message'] ?? 'Registrasi gagal (${response.statusCode})',
        };
      }
    } catch (e) {
      print('Error register user: $e');
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
