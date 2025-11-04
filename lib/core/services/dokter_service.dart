import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dokter_model.dart';
import '../../config/api_home.dart';

class DokterService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<DokterModel>> fetchDokter() async {
    final response = await http.get(Uri.parse('$_baseUrl/dokter'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        List<dynamic> listData = jsonResponse['data'];

        // 🔽 Tambahkan ini untuk debug URL foto
        List<DokterModel> dokterList = listData
            .map((data) => DokterModel.fromJson(data))
            .toList();
        for (var d in dokterList) {
          print('Foto dokter: ${d.fotoProfil}');
        }

        return dokterList;
      } else {
        throw Exception('API status is not success or data is null');
      }
    } else {
      throw Exception(
        'Failed to load dokter data. Status code: ${response.statusCode}',
      );
    }
  }
}
