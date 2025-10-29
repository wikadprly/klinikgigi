import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/models/user_model.dart';

class AuthService {
  // Ganti URL ini dengan base URL API Laravel kamu
  static const String baseUrl = 'http://10.0.2.2:8000/api'; 
  // 10.0.2.2 digunakan agar emulator bisa akses localhost di PC

  // 🟢 Login user
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
        // Pastikan respons Laravel berisi "user"
        if (data['user'] != null) {
          return UserModel.fromJson(data['user']);
        }
      }
      return null; // gagal login
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  // 🟣 Register user baru
  Future<bool> register(UserModel user) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return true; // sukses register
      }
      return false;
    } catch (e) {
      print('Error register: $e');
      return false;
    }
  }

  // 🟡 Ambil profil user (misalnya setelah login)
  Future<UserModel?> getProfile(int userId) async {
    final url = Uri.parse('$baseUrl/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      }
      return null;
    } catch (e) {
      print('Error get profile: $e');
      return null;
    }
  }
}