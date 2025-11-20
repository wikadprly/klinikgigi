import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';
import '../models/master_dokter_model.dart';
import '../models/dokter_detail_model.dart';

class DokterService {
  final String _url = ApiEndpoint.dokter;

  // --- METHOD UNTUK DAFTAR DOKTER ---
  Future<List<MasterDokterModel>> fetchDokter([String? search]) async {
    try {
      var uri = Uri.parse(_url);
      if (search != null && search.isNotEmpty) {
        uri = uri.replace(queryParameters: {'search': search});
      }

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          List<dynamic> listData = jsonResponse['data'];
          List<MasterDokterModel> dokterList = listData
              .map((data) => MasterDokterModel.fromJson(data))
              .toList();

          return dokterList;
        } else {
          throw Exception('API status is not success or data is null');
        }
      } else {
        throw Exception(
          'Failed to load dokter data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Gagal mengambil data dokter: ${e.toString()}');
    }
  }

  // --- METHOD UNTUK DETAIL DOKTER ---
  // PERBAIKAN: Mengubah parameter ke String dan tipe return ke DokterDetailModel
  Future<DokterDetailModel> fetchDokterDetail(String id) async {
    try {
      final uri = Uri.parse('$_url/$id');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          return DokterDetailModel.fromJson(jsonResponse['data']);
        } else {
          throw Exception('API status is not success or data is null');
        }
      } else {
        throw Exception(
          'Failed to load dokter detail. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Gagal mengambil detail dokter: ${e.toString()}');
    }
  }
}
