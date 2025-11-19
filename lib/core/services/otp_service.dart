import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_request_response.dart';
import '../models/otp_verify_response.dart';

class OtpService {
  static const String baseUrl = "http://127.0.0.1:8000/api/auth";

  Future<OtpRequestResponse> requestOtp(String email) async {
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
    final url = Uri.parse("$baseUrl/verify-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    final data = jsonDecode(response.body);

    return OtpVerifyResponse.fromJson(data);
  }
}
