import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_klinik_gigi/config/app_config.dart';

class ProfilService {
  final String baseUrl = AppConfig.apiBaseUrl;

  static final Map<String, dynamic> _demoProfil = {
    'success': true,
    'message': 'Profil demo',
    'data': {
      'user': {
        'id': 2,
        'nama_pengguna': 'Pasien Demo',
        'nik': '3374000000000001',
        'email': 'demo@3kdentalcare.id',
        'no_hp': '081234567890',
        'tanggal_lahir': '2000-01-01',
        'jenis_kelamin': 'Perempuan',
        'file_foto': '',
      },
      'rekam_medis': {
        'id': 2,
        'no_rekam_medis': 'RM-0002',
        'alamat': 'Jl. Kesehatan No. 1, Semarang',
      },
      'nama_asuransi': 'BPJS Kesehatan',
      'no_peserta': '0001234567890',
      'status_aktif': 'Aktif',
    },
  };

  // ========================= GET PROFIL =========================
  Future<Map<String, dynamic>> getProfil(String token) async {
    if (AppConfig.demoMode) {
      return jsonDecode(jsonEncode(_demoProfil)) as Map<String, dynamic>;
    }

    final response = await http.get(
      Uri.parse("$baseUrl/profil"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // ========================= UPDATE PROFIL ======================
  Future<Map<String, dynamic>> updateProfil(
    String token,
    Map<String, dynamic> data,
  ) async {
    if (AppConfig.demoMode) {
      final user = _demoProfil['data']['user'] as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value != null) user[key] = value;
      });
      return {
        'success': true,
        'message': 'Profil demo berhasil diperbarui',
        'data': _demoProfil['data'],
      };
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profil/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

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
          'message': result['message'] ??
              "Gagal update profil (status ${response.statusCode})",
          'raw': result,
        };
      }
    } catch (e) {
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
    XFile imageFile,
  ) async {
    if (AppConfig.demoMode) {
      return {
        'success': true,
        'message': 'Foto profil demo berhasil diperbarui',
      };
    }

    Dio dio = Dio();

    try {
      final bytes = await imageFile.readAsBytes();
      final filename = imageFile.name.isNotEmpty
          ? imageFile.name
          : 'foto_profil.jpg';

      FormData formData = FormData.fromMap({
        'file_foto': MultipartFile.fromBytes(bytes, filename: filename),
      });

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

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ===================== DELETE PROFILE PHOTO =====================
  Future<Map<String, dynamic>> deleteProfilePicture(String token) async {
    if (AppConfig.demoMode) {
      return {
        'success': true,
        'message': 'Foto profil demo berhasil dihapus',
      };
    }

    final response = await http.delete(
      Uri.parse("$baseUrl/profil/hapus/foto"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
