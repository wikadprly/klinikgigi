import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';

class ReservasiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<MasterPoliModel>> getDaftarPoli() async {
    final url = Uri.parse('$baseUrl/reservasi/poli');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> poliList = data['data'] ?? [];
        return poliList.map((e) => MasterPoliModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<MasterDokterModel>> getDokterByPoli(String kodePoli) async {
    final url = Uri.parse('$baseUrl/reservasi/dokter');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'kode_poli': kodePoli}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dokterList = data['data'] ?? [];
        return dokterList.map((e) => MasterDokterModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<MasterJadwalModel>> getJadwal(
      String kodeDokter, String tanggalReservasi) async {
    final url = Uri.parse('$baseUrl/reservasi/jadwal');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kode_dokter': kodeDokter,
          'tanggal_reservasi': tanggalReservasi,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> jadwalList = data['data'] ?? [];
        return jadwalList.map((e) => MasterJadwalModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> createReservasi(Map<String, dynamic> reservasiData) async {
    final url = Uri.parse('$baseUrl/reservasi/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reservasiData),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<List<ReservasiModel>> getRiwayatReservasi(String rekamMedisId) async {
    final url = Uri.parse('$baseUrl/reservasi/riwayat/$rekamMedisId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> riwayatList = data['data'] ?? [];
        return riwayatList.map((e) => ReservasiModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> updatePembayaran(
      String noPemeriksaan, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/reservasi/pembayaran/$noPemeriksaan');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
