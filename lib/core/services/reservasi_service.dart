import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // ✅ WAJIB: Untuk ambil token
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';

class ReservasiService {
  // Ganti IP sesuai network kamu (10.0.2.2 untuk emulator Android bawaan)
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 

  // 🔥 HELPER: Ambil Token & Buat Header
  // Karena route di api.php pakai auth:sanctum, kita wajib kirim token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? ''; // Pastikan key-nya sesuai saat login
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // 🔑 Kunci Masuk
    };
  }

  // 1. Ambil Daftar Poli
  Future<List<MasterPoliModel>> getDaftarPoli() async {
    final url = Uri.parse('$baseUrl/reservasi/poli');
    try {
      final headers = await _getHeaders(); // Ambil header + token
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> poliList = data['data'] ?? [];
        return poliList.map((e) => MasterPoliModel.fromJson(e)).toList();
      } else {
        print("Gagal Get Poli: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error getPoli: $e");
    }
    return [];
  }

  // 2. Ambil Dokter by Poli
  Future<List<MasterDokterModel>> getDokterByPoli(String kodePoli) async {
    final url = Uri.parse('$baseUrl/reservasi/dokter');
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'kode_poli': kodePoli}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dokterList = data['data'] ?? [];
        return dokterList.map((e) => MasterDokterModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error getDokter: $e");
    }
    return [];
  }

  // 3. Ambil Jadwal Sekaligus Kuota (Sesuai Controller Baru)
  Future<List<MasterJadwalModel>> getJadwal({
    required String kodePoli,        
    String? kodeDokter,             
    String? tanggalReservasi,       
  }) async {
    final url = Uri.parse('$baseUrl/reservasi/jadwal');
    
    // Body harus persis dengan validasi di Controller Laravel
    Map<String, dynamic> bodyRequest = {
      'kode_poli': kodePoli, 
    };

    if (kodeDokter != null && kodeDokter != 'semua') {
      bodyRequest['kode_dokter'] = kodeDokter;
    }
    // Controller mengharapkan format Y-m-d, pastikan dari UI sudah benar
    if (tanggalReservasi != null) {
      bodyRequest['tanggal_reservasi'] = tanggalReservasi;
    }

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyRequest),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> jadwalList = data['data'] ?? [];
        return jadwalList.map((e) => MasterJadwalModel.fromJson(e)).toList();
      } else {
        print("Gagal Get Jadwal: ${response.body}");
      }
    } catch (e) {
      print("Error getJadwal: $e");
    }
    return [];
  }

  // 4. Create Reservasi
  Future<Map<String, dynamic>?> createReservasi(Map<String, dynamic> reservasiData) async {
    final url = Uri.parse('$baseUrl/reservasi/create');
    try {
      final headers = await _getHeaders();
      // ⚠️ Pastikan reservasiData berisi 'rekam_medis_id' (Integer), bukan String
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(reservasiData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data']; 
      } else {
        print("Gagal Booking: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error createReservasi: $e");
      return null;
    }
  }

  // 5. Riwayat Reservasi
  Future<List<ReservasiModel>> getRiwayatReservasi(String rekamMedisId) async {
    final url = Uri.parse('$baseUrl/reservasi/riwayat/$rekamMedisId');
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> riwayatList = data['data'] ?? [];
        return riwayatList.map((e) => ReservasiModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error getRiwayat: $e");
    }
    return [];
  }

  // 6. Update Pembayaran
  Future<bool> updatePembayaran(String noPemeriksaan, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/reservasi/pembayaran/$noPemeriksaan');
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updatePembayaran: $e");
      return false;
    }
  }
}