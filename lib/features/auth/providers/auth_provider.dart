import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/services/auth_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  String? _token;
  String? get token => _token;

  bool get isLoggedIn => _user != null && _token != null;

  /// Load user & token when app starts
  Future<void> loadUser() async {
    _user = await SharedPrefsHelper.getUser();
    _token = await SharedPrefsHelper.getToken();
    notifyListeners();
  }

  Future<String?> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(identifier, password);
    _isLoading = false;

    if (result['success'] == true) {
      _user = result['user'];
      _token = await SharedPrefsHelper.getToken(); // ambil token
      notifyListeners();
      return null; // Success (no error)
    } else {
      notifyListeners();
      return result['message'] ?? 'Login gagal'; // Return error message
    }
  }

  Future<void> logout() async {
    await SharedPrefsHelper.clearUser();
    await SharedPrefsHelper.clearToken();
    _user = null;
    _token = null;
    notifyListeners();
  }

  Future<String?> registerUser({
    required String tipePasien,
    String? rekamMedis,
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
    if (password != confirmPassword) {
      throw Exception("Password dan konfirmasi password tidak sama");
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.registerUser(
        tipePasien: tipePasien,
        rekamMedisId: rekamMedis,
        namaPengguna: namaPengguna,
        nik: nik,
        email: email,
        noHp: noHp,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
        alamat: alamat,
        password: password,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        return null; // Success
      } else {
        return result['message'] ?? 'Registrasi gagal';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error register user: $e");
      return "Terjadi kesalahan sistem: $e";
    }
  }
}
