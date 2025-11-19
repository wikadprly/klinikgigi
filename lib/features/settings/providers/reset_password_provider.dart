import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/services/reset_password_service.dart';

class ResetPasswordProvider extends ChangeNotifier {
  final ResetPasswordService _resetService = ResetPasswordService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _resetService.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      _isLoading = false;

      // Bisa disesuaikan tergantung response backendmu
      _message = result["message"] ?? "Berhasil mengganti password";
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _message = "Gagal mengganti password: $e";
      notifyListeners();
      return false;
    }
  }
}
