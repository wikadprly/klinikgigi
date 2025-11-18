import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/riwayat_model.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class RiwayatService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<RiwayatModel>> fetchRiwayat() async {
    final token = await SharedPrefsHelper.getUser();

    final response = await http.get(
      Uri.parse('$baseUrl/riwayat'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Ambil data dari key "data"
      List<dynamic> data = jsonResponse['data'];

      return data.map((item) => RiwayatModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data riwayat: ${response.statusCode}');
    }
  }
}
