import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilService {
  final String baseUrl = "http://127.0.0.1:8000/api"; // sesuaikan

  Future<Map<String, dynamic>> getProfil(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProfil(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/profil/update"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
      body: data,
    );

    return jsonDecode(response.body);
  }
}
