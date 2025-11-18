import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';

class SharedPrefsHelper {
  static const String keyUser = 'user_data';
  static const String keyToken = 'auth_token';

  // Simpan data user
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUser, jsonEncode(user.toJson()));
  }

  // Ambil data user
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keyUser);
    if (jsonString == null) return null;

    try {
      final data = jsonDecode(jsonString);
      return UserModel.fromJson(data);
    } catch (e) {
      print("Error parsing user data: $e");
      return null;
    }
  }

  // Hapus data user (logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUser);
  }

  // Simpan token (untuk hasil verify OTP)
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  // Hapus token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUser);
    await prefs.remove(keyToken);
  }
}
