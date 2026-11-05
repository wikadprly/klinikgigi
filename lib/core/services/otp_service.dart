import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/otp_request_response.dart';
import '../models/otp_verify_response.dart';
import '../../config/app_config.dart';

class OtpService {
  static const String baseUrl = "${AppConfig.apiBaseUrl}/auth";

  Future<OtpRequestResponse> requestOtp(String email) async {
    if (AppConfig.demoMode) {
      return OtpRequestResponse(
        success: true,
        message: 'Kode OTP demo: 123456',
      );
    }

    final url = Uri.parse("$baseUrl/request-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    return OtpRequestResponse.fromJson(data);
  }

  Future<OtpVerifyResponse> verifyOtp(String email, String code) async {
    if (AppConfig.demoMode) {
      return OtpVerifyResponse(
        success: true,
        message: 'Verifikasi OTP demo berhasil',
        data: {
          'user_id': '2',
          'nama_pengguna': 'Pasien Demo',
          'email': email,
          'token': 'demo-token',
          'token_expires_in': 3600,
        },
      );
    }

    final url = Uri.parse("$baseUrl/verify-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    final data = jsonDecode(response.body);

    return OtpVerifyResponse.fromJson(data);
  }
  /// Request OTP RESET PASSWORD
  Future<bool> requestResetPassword(String email) async {
    if (AppConfig.demoMode) return true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/request-reset-password"),
        body: {"email": email},
      );

      final data = jsonDecode(response.body);
      return data["success"] == true;

    } catch (e) {
      debugPrint("Error requestResetPassword: $e");
      return false;
    }
  }

  /// Verifikasi OTP RESET PASSWORD & dapatkan reset_token
  Future<OtpVerifyResponse> verifyResetPassword(String otp) async {
    if (AppConfig.demoMode) {
      return OtpVerifyResponse(
        success: true,
        message: 'Verifikasi OTP demo berhasil',
        resetToken: 'demo-reset-token',
      );
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/verify-reset-password"),
        body: {"otp": otp},
      );

      final data = jsonDecode(response.body);
      return OtpVerifyResponse.fromJson(data);

    } catch (e) {
      debugPrint("Error verifyResetPassword: $e");
      return OtpVerifyResponse(
        success: false,
        message: "Terjadi kesalahan",
        resetToken: null,
      );
    }
  }

  /// Update password menggunakan reset_token
  Future<bool> updatePassword({
    required String resetToken,
    required String password,
  }) async {
    if (AppConfig.demoMode) return true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/reset-password"),
        body: {
          "reset_token": resetToken,
          "password": password,
        },
      );

      final data = jsonDecode(response.body);
      return data["success"] == true;

    } catch (e) {
      debugPrint("Error updatePassword: $e");
      return false;
    }
  }
}
