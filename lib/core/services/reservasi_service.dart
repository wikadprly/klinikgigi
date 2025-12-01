import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';

class ReservasiService {
  // Pastikan IP ini sesuai dengan settingan laravel serve kamu (kalau di emulator pakai 10.0.2.2)
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 

  // 1. Ambil Daftar Poli (AMAN)
  Future<List<MasterPoliModel>> getDaftarPoli() async {
    final url = Uri.parse('$baseUrl/reservasi/poli');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> poliList = data['data'] ?? [];
        return poliList.map((e) => MasterPoliModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error getPoli: $e");
    }
    return [];
  }

  // 2. Ambil Dokter by Poli (AMAN)
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
    } catch (e) {
      print("Error getDokter: $e");
    }
    return [];
  }

  // 3. Ambil Jadwal Sekaligus Kuota (PERUBAHAN BESAR DISINI)
  // Backend baru mewajibkan kodePoli, sedangkan dokter & tanggal opsional
  Future<List<MasterJadwalModel>> getJadwal({
    required String kodePoli,       // WAJIB ADA
    String? kodeDokter,             // Boleh null (opsional)
    String? tanggalReservasi,       // Boleh null (opsional)
  }) async {
    final url = Uri.parse('$baseUrl/reservasi/jadwal');
    
    // Siapkan body request
    Map<String, dynamic> bodyRequest = {
      'kode_poli': kodePoli, 
    };

    if (kodeDokter != null && kodeDokter != 'semua') {
      bodyRequest['kode_dokter'] = kodeDokter;
    }
    if (tanggalReservasi != null) {
      bodyRequest['tanggal_reservasi'] = tanggalReservasi;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
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

  // ❌ Function getKuota DIHAPUS karena backendnya sudah tidak ada.
  // Datanya (sisa_kuota) sudah otomatis nempel di dalam response getJadwal di atas.

  // 4. Create Reservasi (MODIFIKASI RETURN)
  // Aku ubah jadi return Map biar kamu bisa dapet 'no_pemeriksaan' dll buat navigasi
  Future<Map<String, dynamic>?> createReservasi(Map<String, dynamic> reservasiData) async {
    final url = Uri.parse('$baseUrl/reservasi/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reservasiData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data']; // Mengembalikan data sukses (isi no_pemeriksaan, total_bayar, dll)
      } else {
        print("Gagal Booking: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error createReservasi: $e");
      return null;
    }
  }

  // 5. Riwayat Reservasi (AMAN)
  Future<List<ReservasiModel>> getRiwayatReservasi(String rekamMedisId) async {
    final url = Uri.parse('$baseUrl/reservasi/riwayat/$rekamMedisId');
    try {
      final response = await http.get(url);
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

  // 6. Update Pembayaran (AMAN)
  Future<bool> updatePembayaran(String noPemeriksaan, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/reservasi/pembayaran/$noPemeriksaan');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updatePembayaran: $e");
      return false;
    }
  }
}