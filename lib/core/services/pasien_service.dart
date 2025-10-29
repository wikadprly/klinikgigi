// lib/services/pasien_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pasien_model.dart';
import '../../config/api_home.dart';

class PasienService {
  Future<Pasien> getPasienByUserId(String userId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/get_pasien.php?user_id=$userId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null && data['status'] == 'error') {
        throw Exception(data['message']);
      }

      return Pasien.fromJson(data);
    } else {
      throw Exception(
        'Gagal memuat data pasien. Status Code: ${response.statusCode}',
      );
    }
  }
}
