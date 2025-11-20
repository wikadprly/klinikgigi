import 'package:dio/dio.dart';

class ResetPasswordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://127.0.0.1:8000/api"));

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      "/auth/reset-password",
      data: {
        "reset_token": token,
        "new_password": newPassword,
      },
    );
    return response.data;
  }
}
