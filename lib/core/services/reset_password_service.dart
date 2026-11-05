import 'package:dio/dio.dart';
import '../../config/app_config.dart';

class ResetPasswordService {
  final Dio _dio;

  ResetPasswordService(String token)
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

  Future<Map<String, dynamic>> requestOtp() async {
    if (AppConfig.demoMode) {
      return {'success': true, 'message': 'Kode OTP demo: 123456'};
    }

    final response = await _dio.post("/password/request-change");
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp({required String otp}) async {
    if (AppConfig.demoMode) {
      return {'success': true, 'message': 'Verifikasi OTP demo berhasil'};
    }

    final response = await _dio.post(
      "/password/verify-change",
      data: {"otp": otp}, // FIXED
    );
    return response.data;
  }

  Future<Map<String, dynamic>> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (AppConfig.demoMode) {
      return {'success': true, 'message': 'Password demo berhasil diubah'};
    }

    final response = await _dio.post(
      "/password/reset", // FIXED
      data: {
        "password_baru": newPassword,
        "password_baru_confirmation": confirmPassword,
      }, // FIXED
    );
    return response.data;
  }
}
