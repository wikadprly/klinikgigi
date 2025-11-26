import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilService {
  final String baseUrl = "http://192.168.0.106"; // sesuaikan dengan IP server kamu

  // GET PROFIL
  Future<Map<String, dynamic>> getProfil(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("STATUS GET: ${response.statusCode}");
    print("RESPONSE GET: ${response.body}");

    return jsonDecode(response.body);
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
