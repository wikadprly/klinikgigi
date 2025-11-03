import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';

class SharedPrefsHelper {
  static const String keyUser = 'user_data';

  // Simpan data user ke SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUser, jsonEncode(user.toJson()));
  }

  // Ambil data user dari SharedPreferences
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
}
