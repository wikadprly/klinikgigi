import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // 🔹 LOGIN
  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          return UserModel.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  // 🔹 REGISTER USER (baru/lama)
  Future<bool> registerUser({
    required String tipePasien,
    String? rekamMedisId,
    String? namaPengguna,
    String? nik,
    String? email,
    String? noHp,
    String? tanggalLahir,
    String? jenisKelamin,
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
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print("Response register (${response.statusCode}): ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error register user: $e');
      return false;
    }
  }
}
