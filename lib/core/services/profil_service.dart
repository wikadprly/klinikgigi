import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilService {
  final String baseUrl = "http://127.0.0.1:8000/api"; // sesuaikan dengan IP server kamu

  // GET PROFIL
  Future<Map<String, dynamic>> getProfil(String token) async {
    print("Fetching profile with token: ${token.length > 0 ? '***' : 'empty'}");
    print("API URL: $baseUrl/profil");

    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("STATUS GET: ${response.statusCode}");
    print("RESPONSE GET: ${response.body}");

    Map<String, dynamic> result = jsonDecode(response.body);
    print("Parsed result: $result");

    return result;
  }

  // UPDATE PROFIL
  Future<Map<String, dynamic>> updateProfil(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/profil/update"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    print("STATUS UPDATE: ${response.statusCode}");
    print("RESPONSE UPDATE: ${response.body}");

    return jsonDecode(response.body);
  }
}
