import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ProfilService {
  final String baseUrl = "https://pbl250116.informatikapolines.id/api";

  // ========================= GET PROFIL =========================
  Future<Map<String, dynamic>> getProfil(String token) async {
    print("Fetching profile...");
    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATUS GET: ${response.statusCode}");
    print("RESPONSE GET: ${response.body}");
    return jsonDecode(response.body);
  }

  // ========================= UPDATE PROFIL ======================
  Future<Map<String, dynamic>> updateProfil(
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      print("🚀 Updating profile...");
      print("📤 Body: $data");

      // CORRECT ENDPOINT: /profil/update
      final response = await http.post(
        Uri.parse('$baseUrl/profil/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      print("📡 STATUS UPDATE: ${response.statusCode}");
      print("📡 BODY UPDATE: ${response.body}");

      final result = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': result['message'],
          'data': result['data'],
        };
      } else if (response.statusCode == 422) {
        return {
          'success': false,
          'message': _parseValidationErrors(result['errors']),
          'errors': result['errors'],
        };
      } else {
        return {
          'success': false,
          'message':
              result['message'] ??
              "Gagal update profil (status ${response.statusCode})",
          'raw': result,
        };
      }
    } catch (e) {
      print("❌ ERROR UPDATE SERVICE: $e");
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  String _parseValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return "Validasi gagal";
    List<String> list = [];
    errors.forEach((key, value) {
      if (value is List) list.addAll(value.map((e) => e.toString()));
    });
    return list.join(", ");
  }

  // ===================== UPDATE PROFILE PHOTO =====================
  Future<Map<String, dynamic>> updateProfilePicture(
    String token,
    File imageFile,
  ) async {
    Dio dio = Dio();

    if (!await imageFile.exists()) {
      throw Exception('File does not exist at path: ${imageFile.path}');
    }

    try {
      FormData formData = FormData.fromMap({
        'foto': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('\\').last.split('/').last,
        ),
      });

      Response response = await dio.post(
        "$baseUrl/profil/upload",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("STATUS UPDATE PHOTO: ${response.statusCode}");
      print("RESPONSE UPDATE PHOTO: ${response.data}");

      return response.data;
    } catch (e) {
      print("Error uploading photo: $e");
      rethrow;
    }
  }

  // ===================== GET PROFILE PHOTO =====================
  Future<Map<String, dynamic>?> getProfilePhoto(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/profil/get"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATUS GET FOTO: ${response.statusCode}");
    print("RESPONSE GET FOTO: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // ===================== DELETE PROFILE PHOTO (JANGAN DIUBAH) =====================
  Future<Map<String, dynamic>> deleteProfilePicture(String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/profil/delete"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATUS DELETE PHOTO: ${response.statusCode}");
    print("RESPONSE DELETE PHOTO: ${response.body}");

    return jsonDecode(response.body);
  }
}
