import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

class ProfilService {
  final String baseUrl =
      "http://127.0.0.1:8000/api"; // sesuaikan dengan IP server kamu

  // GET PROFIL
  Future<Map<String, dynamic>> getProfil(String token) async {
    print("Fetching profile with token: ${token.length > 0 ? '***' : 'empty'}");
    print("API URL: $baseUrl/profil");

    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATUS GET: ${response.statusCode}");
    print("RESPONSE GET: ${response.body}");

    Map<String, dynamic> result = jsonDecode(response.body);
    print("Parsed result: $result");

    return result;
  }

  // UPDATE PROFIL
  Future<Map<String, dynamic>> updateProfil(
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      print("🚀 Starting profile update...");
      print("📤 Data to send: $data");

      // Use POST method for /profil endpoint as defined in the Laravel routes
      final response = await http.post(
        Uri.parse('$baseUrl/profil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      print("📡 API Response Status: ${response.statusCode}");
      print("📡 API Response Body: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Profil berhasil diupdate',
          'data': responseData['data'],
        };
      } else if (response.statusCode == 422) {
        // Handle validation errors
        final errors = responseData['errors'] ?? {};
        final errorMessage = _parseValidationErrors(errors);
        return {'success': false, 'message': errorMessage, 'errors': errors};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengupdate profil (Status: ${response.statusCode})',
          'error': responseData,
        };
      }
    } catch (e) {
      print("❌ Service error: $e");
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  String _parseValidationErrors(Map<String, dynamic> errors) {
    if (errors.isEmpty) return "Validasi gagal";

    final errorMessages = [];
    errors.forEach((key, value) {
      if (value is List) {
        errorMessages.addAll(value.map((e) => e.toString()));
      }
    });

    return errorMessages.join(", ");
  }

  // UPDATE PROFILE PICTURE
  Future<Map<String, dynamic>> updateProfilePicture(
    String token,
    File imageFile,
  ) async {
    // Use Dio for file upload which handles Windows paths better
    Dio dio = Dio();

    // Ensure file exists before attempting upload
    if (!await imageFile.exists()) {
      throw Exception('File does not exist at path: ${imageFile.path}');
    }

    try {
      // Prepare the form data
      FormData formData = FormData.fromMap({
        'file_foto': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('\\').last.split('/').last,
        ),
      });

      // Make the API request
      Response response = await dio.post(
        "$baseUrl/profil/update/foto",
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

  // DELETE PROFILE PICTURE
  Future<Map<String, dynamic>> deleteProfilePicture(String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/profil/hapus/foto"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("STATUS DELETE PHOTO: ${response.statusCode}");
    print("RESPONSE DELETE PHOTO: ${response.body}");

    return jsonDecode(response.body);
  }
}