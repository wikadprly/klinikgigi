import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  // 🔹 Fungsi register pasien baru / lama
  Future<bool> registerUser({
    required String tipePasien,
    String? rekamMedis,
    String? namaPengguna,
    String? nik,
    String? email,
    String? noHp,
    String? tanggalLahir,
    String? jenisKelamin,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception("Password dan konfirmasi password tidak sama");
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.registerUser(
        tipePasien: tipePasien,
        rekamMedisId: rekamMedis,
        namaPengguna: namaPengguna,
        nik: nik,
        email: email,
        noHp: noHp,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelamin,
        password: password,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error register user: $e");
      return false;
    }
  }

  // 🔹 Login user
  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.login(identifier, password);
    _isLoading = false;

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }
}
