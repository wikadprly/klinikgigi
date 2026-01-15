import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';
import 'package:flutter_klinik_gigi/config/api.dart';

class ReservasiService {
  // Pastikan URL ini sesuai dengan environment kamu (emulator: 10.0.2.2, device: IP Laptop)
  static const String baseUrl = 'https://pbl250116.informatikapolines.id/api';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. Ambil Daftar Poli
  Future<List<MasterPoliModel>> getDaftarPoli() async {
    final url = Uri.parse(ApiEndpoint.reservasiGetPoli);
    try {
      final headers = await _getHeaders();
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
    final url = Uri.parse(ApiEndpoint.reservasiGetDokter);
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

  // 3. Ambil Jadwal Sekaligus Kuota (Updated to use jadwal_harian as primary reference)
  Future<List<MasterJadwalModel>> getJadwal({
    required String kodePoli,
    String? kodeDokter,
    String? tanggalReservasi,
  }) async {
    final url = Uri.parse(ApiEndpoint.reservasiGetJadwal);
    Map<String, dynamic> bodyRequest = {'kode_poli': kodePoli};

    if (kodeDokter != null && kodeDokter != 'semua') {
      bodyRequest['kode_dokter'] = kodeDokter;
    }
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
  Future<Map<String, dynamic>?> createReservasi(
    Map<String, dynamic> reservasiData,
  ) async {
    final url = Uri.parse(ApiEndpoint.reservasiCreate);
    try {
      final headers = await _getHeaders();
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
    // Pastikan ApiEndpoint.riwayat sudah terdefinisi menerima parameter string
    final url = Uri.parse(ApiEndpoint.riwayat(rekamMedisId));
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
  Future<bool> updatePembayaran(
    String noPemeriksaan,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse(ApiEndpoint.updatePembayaran(noPemeriksaan));
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

  // 7. Create Reservasi with Payment (Midtrans)
  Future<Map<String, dynamic>?> createReservasiWithPayment(
    Map<String, dynamic> reservasiData,
  ) async {
    final url = Uri.parse(ApiEndpoint.reservasiCreate);
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(reservasiData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        print("Gagal create reservasi with payment: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error createReservasiWithPayment: $e");
      return null;
    }
  }

  // 8. Get Tanggal Dengan Jadwal (FIXED: Return List Map)
  // Mengubah return type dari List<String> ke List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getTanggalDenganJadwal({
    String? kodePoli,
    String? kodeDokter,
  }) async {
    final url = Uri.parse(ApiEndpoint.reservasiGetTanggalDenganJadwal);
    Map<String, dynamic> bodyRequest = {};

    if (kodePoli != null) {
      bodyRequest['kode_poli'] = kodePoli;
    }
    if (kodeDokter != null) {
      bodyRequest['kode_dokter'] = kodeDokter;
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
        final List<dynamic> tanggalList = data['data'] ?? [];
        // Kita cast ke List<Map<String, dynamic>> agar bisa diambil field 'tanggal', 'nama_hari', dll
        return tanggalList.cast<Map<String, dynamic>>();
      } else {
        print("Gagal Get Tanggal Dengan Jadwal: ${response.body}");
      }
    } catch (e) {
      print("Error getTanggalDenganJadwal: $e");
    }
    return [];
  }

  // 9. Get Dokter Dengan Jadwal (FIXED: Return List Map)
  // Mengubah return type dari List<String> ke List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> getDokterDenganJadwal({
    required String kodePoli,
    required String tanggalReservasi,
  }) async {
    final url = Uri.parse(ApiEndpoint.reservasiGetDokterDenganJadwal);
    Map<String, dynamic> bodyRequest = {
      'kode_poli': kodePoli,
      'tanggal_reservasi': tanggalReservasi,
    };

    try {
      final headers = await _getHeaders();
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyRequest),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> dokterList = data['data'] ?? [];
        // Kita cast ke List<Map<String, dynamic>> agar data lengkap dokter terbaca
        return dokterList.cast<Map<String, dynamic>>();
      } else {
        print("Gagal Get Dokter Dengan Jadwal: ${response.body}");
      }
    } catch (e) {
      print("Error getDokterDenganJadwal: $e");
    }
    return [];
  }

  // 10. Check Payment Status
  Future<Map<String, dynamic>?> checkPaymentStatus(String noPemeriksaan) async {
    final url = Uri.parse(ApiEndpoint.cekStatusPembayaran(noPemeriksaan));
    try {
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        print("Gagal check payment status: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error checkPaymentStatus: $e");
      return null;
    }
  }
}
