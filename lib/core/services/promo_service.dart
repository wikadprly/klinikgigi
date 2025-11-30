import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promo_model.dart';
import '../../config/api.dart'; // Menggunakan file config utama

class PromoService {
  // Ambil URL dari ApiConfig
  final String _url = '$baseUrl/promo';

  Future<List<PromoModel>> fetchPromos() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          List<dynamic> listData = jsonResponse['data'];
          return listData.map((data) => PromoModel.fromJson(data)).toList();
        } else {
          throw Exception('Gagal memuat data promo: Format API tidak sesuai');
        }
      } else {
        throw Exception(
          'Gagal memuat data promo. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Tambahkan print untuk melihat error di konsol debug
      print('Error di PromoService: $e');
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}
