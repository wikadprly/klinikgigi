import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/user_data.dart';
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
    }

    loading = false;
    notifyListeners();
    return result;
  }
}
