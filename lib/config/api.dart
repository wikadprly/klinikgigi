// lib/config/api.dart

const String baseUrl = "http://127.0.0.1:8000/api"; // kalau pakai emulator

class ApiEndpoint {
  // AUTH
  static const login = "$baseUrl/login";
  static const register = "$baseUrl/register";
  static const logout = "$baseUrl/logout";
  static const check = "$baseUrl/check";
}
