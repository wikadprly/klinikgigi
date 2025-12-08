import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/services/reset_password_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class ChangePasswordProvider with ChangeNotifier {
  ResetPasswordService? _service;

  ChangePasswordProvider();

  Future<void> initializeService() async {
    String? token = await SharedPrefsHelper.getToken();
    print("TOKEN didapat dari SharedPrefsHelper: $token");
    _service = ResetPasswordService(token ?? "");
    notifyListeners();
  }

  // GLOBAL LOADING
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ================= REQUEST OTP =================
  DateTime? _lastOtpRequestAt;
  bool _isRequestingOtp = false;

  Future<bool> requestOtp() async {
    if (_isRequestingOtp) return false;

    // Anti-spam minimal 1 sec
    if (_lastOtpRequestAt != null &&
        DateTime.now().difference(_lastOtpRequestAt!).inSeconds < 1) {
      return false;
    }

    // Tunggu sampai service diinisialisasi
    if (_service == null) {
      await initializeService();
    }

    _isRequestingOtp = true;
    _setLoading(true);
    _lastOtpRequestAt = DateTime.now();

    try {
      final response = await _service!.requestOtp();
      print("Request OTP Response: $response");

      return (response["success"] == true ||
          response["status"] == true ||
          response["ok"] == true);
    } finally {
      _isRequestingOtp = false;
      _setLoading(false);
    }
  }

  // ================= VERIFY OTP =================
  bool _isVerifyingOtp = false;

  Future<bool> verifyOtp(String otp) async {
    if (_isVerifyingOtp) return false;

    // Tunggu sampai service diinisialisasi
    if (_service == null) {
      await initializeService();
    }

    _isVerifyingOtp = true;
    _setLoading(true);

    try {
      final response = await _service!.verifyOtp(otp: otp);
      print("Verify OTP Response: $response");

      return (response["success"] == true ||
          response["status"] == true ||
          response["verified"] == true);
    } finally {
      _isVerifyingOtp = false;
      _setLoading(false);
    }
  }

  // ================= CHANGE PASSWORD =================
  bool _isChangingPassword = false;

  Future<bool> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_isChangingPassword) return false;

    // Tunggu sampai service diinisialisasi
    if (_service == null) {
      await initializeService();
    }

    _isChangingPassword = true;
    _setLoading(true);

    try {
      final response = await _service!.resetPassword(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      print("Change Password Response: $response");

      return (response["success"] == true ||
          response["status"] == true ||
          response["changed"] == true);
    } finally {
      _isChangingPassword = false;
      _setLoading(false);
    }
  }
}
