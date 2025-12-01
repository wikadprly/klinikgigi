import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_klinik_gigi/core/models/nota_model.dart';
import 'package:flutter_klinik_gigi/config/api.dart' show ApiEndpoint;

class NotaService {
  Future<NotaPelunasanModel> getNotaPelunasan(String noPemeriksaan) async {
    try {
      final url = ApiEndpoint.notaDetail(noPemeriksaan);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NotaPelunasanModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to load nota: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> updateMetodePembayaran(
    String noPemeriksaan,
    String metodePembayaran,
  ) async {
    try {
      final url = ApiEndpoint.notaMetodePembayaran;
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'no_pemeriksaan': noPemeriksaan,
          'metode_pembayaran': metodePembayaran,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update metode pembayaran');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> submitPembayaran(
    String noPemeriksaan,
    String metodePembayaran,
  ) async {
    try {
      final url = ApiEndpoint.notaPembayaran;
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'no_pemeriksaan': noPemeriksaan,
          'metode_pembayaran': metodePembayaran,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to submit pembayaran');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> downloadInvoice(String noPemeriksaan) async {
    try {
      final url = ApiEndpoint.notaInvoice(noPemeriksaan);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body; // PDF content as string
      } else {
        throw Exception('Failed to download invoice');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
