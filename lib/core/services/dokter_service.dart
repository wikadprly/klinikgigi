import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dokter_model.dart';
import '../../config/api.dart';

class DokterService {
  // mengambil URL dari file config yang sudah benar
  final String _url =
      ApiEndpoint.dokter; // Menggunakan 'http://127.0.0.1:8000/api/dokter'

  Future<List<DokterModel>> fetchDokter() async {
    // menggunakan _url yang sudah didefinisikan
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
        List<dynamic> listData = jsonResponse['data'];

        // menambahkan ini untuk debug URL foto
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
