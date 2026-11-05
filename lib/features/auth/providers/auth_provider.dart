import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/services/auth_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/config/app_config.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  String? _token;
  String? get token => _token;

  bool get isLoggedIn => _user != null && _token != null;

  static final UserModel _demoUser = UserModel(
    userId: '2',
    namaPengguna: 'Pasien Demo',
    nik: '3374000000000001',
    rekamMedisId: 2,
    tanggalLahir: '2000-01-01',
    jenisKelamin: 'Perempuan',
    noHp: '081234567890',
    email: 'demo@3kdentalcare.id',
    password: '',
  );

  /// Load user & token when app starts
  Future<void> loadUser() async {
    _user = await SharedPrefsHelper.getUser();
    _token = await SharedPrefsHelper.getToken();
    notifyListeners();
  }

  /// Aktifkan sesi demo tanpa backend (dipakai saat build web portofolio).
  Future<void> enableDemoSession() async {
    if (!AppConfig.demoMode) return;
    if (isLoggedIn) return;

    _user = _demoUser;
    _token = 'demo-token';
    await SharedPrefsHelper.saveUser(_demoUser);
    await SharedPrefsHelper.saveToken('demo-token');
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.demoMode) {
      _user = _demoUser;
      _token = 'demo-token';
      await SharedPrefsHelper.saveUser(_demoUser);
      await SharedPrefsHelper.saveToken('demo-token');
      _isLoading = false;
      notifyListeners();
      return true;
    }

    final user = await _authService.login(identifier, password);
    _isLoading = false;

    if (user != null) {
      _user = user;
      _token = await SharedPrefsHelper.getToken(); // ambil token
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await SharedPrefsHelper.clearUser();
    await SharedPrefsHelper.clearToken();
    _user = null;
    _token = null;
    notifyListeners();
  }

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
}
