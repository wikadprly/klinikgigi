import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_data.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/core/services/otp_service.dart';
import 'package:flutter_klinik_gigi/core/models/otp_request_response.dart';
import 'package:flutter_klinik_gigi/core/models/otp_verify_response.dart';

class OtpProvider with ChangeNotifier {
  final OtpService _otpService = OtpService();

  bool loading = false;
  UserData? user;

  Future<OtpRequestResponse> requestOtp(String email) async {
    loading = true;
    notifyListeners();

    final result = await _otpService.requestOtp(email);

    loading = false;
    notifyListeners();

    return result;
  }

  Future<OtpVerifyResponse> verifyOtp(String email, String code) async {
    loading = true;
    notifyListeners();

    final result = await _otpService.verifyOtp(email, code);

    if (result.success && result.data != null) {
      user = UserData.fromJson(result.data!);

      // Persist token if present in response data or in parsed user
      try {
        String? token;
        if (result.data!['token'] != null && result.data!['token'] is String) {
          token = result.data!['token'];
        } else if (result.data!['access_token'] != null &&
            result.data!['access_token'] is String) {
          token = result.data!['access_token'];
        } else if (user != null && user!.token.isNotEmpty) {
          token = user!.token;
        }

        if (token != null && token.isNotEmpty) {
          await SharedPrefsHelper.saveToken(token);
        }
      } catch (e) {
        debugPrint('Warning: gagal menyimpan token OTP: $e');
      }
    }

    loading = false;
    notifyListeners();
    return result;
  }
}
