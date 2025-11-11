import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/riwayat_model.dart';

class RiwayatService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<RiwayatModel>> fetchRiwayat() async {
    final response = await http.get(Uri.parse('$baseUrl/riwayat'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => RiwayatModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data riwayat');
    }
  }
}
