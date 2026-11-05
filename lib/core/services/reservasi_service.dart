import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_dokter_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/reservasi_model.dart';
import 'package:flutter_klinik_gigi/config/api.dart';
import 'package:flutter_klinik_gigi/config/app_config.dart';

class ReservasiService {
  static const String baseUrl = AppConfig.apiBaseUrl;

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
    if (AppConfig.demoMode) {
      return [
        MasterPoliModel(
          kodePoli: 'POL-01',
          namaPoli: 'Poli Gigi Umum',
          keterangan: 'Pemeriksaan dan perawatan gigi umum',
        ),
        MasterPoliModel(
          kodePoli: 'POL-02',
          namaPoli: 'Poli Ortodonti',
          keterangan: 'Perawatan behel dan susunan gigi',
        ),
        MasterPoliModel(
          kodePoli: 'POL-03',
          namaPoli: 'Poli Bedah Mulut',
          keterangan: 'Tindakan bedah pada gigi dan mulut',
        ),
      ];
    }

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
    if (AppConfig.demoMode) {
      final dokter = <String, List<MasterDokterModel>>{
        'POL-01': [
          MasterDokterModel(
            kodeDokter: 'DOK-01',
            kodePoli: 'POL-01',
            nama: 'Bagus Pratama',
            gelar: 'drg.',
            spesialisasi: 'Dokter Gigi Umum',
            alamat: '-',
            hp: '-',
            tipe: '-',
            dokterStr: '-',
            dokterStrMulai: '-',
            dokterStrExpire: '-',
            dokterSip: '-',
            dokterSipBerlaku: '-',
            dokterSipExpired: '-',
            inisial: 'BP',
            poliNama: 'Poli Gigi Umum',
          ),
          MasterDokterModel(
            kodeDokter: 'DOK-02',
            kodePoli: 'POL-01',
            nama: 'Ayu Lestari',
            gelar: 'drg.',
            spesialisasi: 'Dokter Gigi Umum',
            alamat: '-',
            hp: '-',
            tipe: '-',
            dokterStr: '-',
            dokterStrMulai: '-',
            dokterStrExpire: '-',
            dokterSip: '-',
            dokterSipBerlaku: '-',
            dokterSipExpired: '-',
            inisial: 'AL',
            poliNama: 'Poli Gigi Umum',
          ),
        ],
        'POL-02': [
          MasterDokterModel(
            kodeDokter: 'DOK-03',
            kodePoli: 'POL-02',
            nama: 'Citra Dewi',
            gelar: 'drg., Sp.Ort',
            spesialisasi: 'Ortodonti',
            alamat: '-',
            hp: '-',
            tipe: '-',
            dokterStr: '-',
            dokterStrMulai: '-',
            dokterStrExpire: '-',
            dokterSip: '-',
            dokterSipBerlaku: '-',
            dokterSipExpired: '-',
            inisial: 'CD',
            poliNama: 'Poli Ortodonti',
          ),
        ],
        'POL-03': [
          MasterDokterModel(
            kodeDokter: 'DOK-04',
            kodePoli: 'POL-03',
            nama: 'Dimas Saputra',
            gelar: 'drg., Sp.BM',
            spesialisasi: 'Bedah Mulut',
            alamat: '-',
            hp: '-',
            tipe: '-',
            dokterStr: '-',
            dokterStrMulai: '-',
            dokterStrExpire: '-',
            dokterSip: '-',
            dokterSipBerlaku: '-',
            dokterSipExpired: '-',
            inisial: 'DS',
            poliNama: 'Poli Bedah Mulut',
          ),
        ],
      };
      return dokter[kodePoli] ?? [];
    }

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

  // 3. Ambil Jadwal Sekaligus Kuota
  Future<List<MasterJadwalModel>> getJadwal({
    required String kodePoli,
    String? kodeDokter,
    String? tanggalReservasi,
  }) async {
    if (AppConfig.demoMode) {
      final all = [
        MasterJadwalModel(
          id: 101,
          kodeDokter: 'DOK-01',
          kodePoli: 'POL-01',
          hari: 'Senin',
          jamMulai: '09:00',
          jamSelesai: '12:00',
          keterangan: 'Praktek pagi',
          quota: 8,
          kuotaTerpakai: 3,
          sisaKuota: 5,
          statusJadwal: 'Tersedia',
          tanggalPilih: tanggalReservasi,
        ),
        MasterJadwalModel(
          id: 102,
          kodeDokter: 'DOK-02',
          kodePoli: 'POL-01',
          hari: 'Senin',
          jamMulai: '13:00',
          jamSelesai: '16:00',
          keterangan: 'Praktek siang',
          quota: 8,
          kuotaTerpakai: 2,
          sisaKuota: 6,
          statusJadwal: 'Tersedia',
          tanggalPilih: tanggalReservasi,
        ),
        MasterJadwalModel(
          id: 103,
          kodeDokter: 'DOK-03',
          kodePoli: 'POL-02',
          hari: 'Selasa',
          jamMulai: '10:00',
          jamSelesai: '14:00',
          keterangan: 'Praktek ortodonti',
          quota: 6,
          kuotaTerpakai: 1,
          sisaKuota: 5,
          statusJadwal: 'Tersedia',
          tanggalPilih: tanggalReservasi,
        ),
        MasterJadwalModel(
          id: 104,
          kodeDokter: 'DOK-04',
          kodePoli: 'POL-03',
          hari: 'Rabu',
          jamMulai: '08:00',
          jamSelesai: '11:00',
          keterangan: 'Praktek bedah mulut',
          quota: 4,
          kuotaTerpakai: 0,
          sisaKuota: 4,
          statusJadwal: 'Tersedia',
          tanggalPilih: tanggalReservasi,
        ),
      ];
      return all.where((j) {
        if (j.kodePoli != kodePoli) return false;
        if (kodeDokter != null && kodeDokter != 'semua' && kodeDokter.isNotEmpty) {
          return j.kodeDokter == kodeDokter;
        }
        return true;
      }).toList();
    }

    final url = Uri.parse(ApiEndpoint.reservasiGetJadwal);
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
    if (AppConfig.demoMode) {
      return {
        'no_pemeriksaan': 'DEMO-RSV-${DateTime.now().millisecondsSinceEpoch}',
        'no_antrian': 'A-01',
        'status_pembayaran': 'lunas',
        'is_lunas': true,
        'total': 50000,
      };
    }

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
  Future<bool> updatePembayaran(String noPemeriksaan, Map<String, dynamic> data) async {
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
  Future<Map<String, dynamic>?> createReservasiWithPayment(Map<String, dynamic> reservasiData) async {
    if (AppConfig.demoMode) {
      return {
        'no_pemeriksaan': 'DEMO-RSV-${DateTime.now().millisecondsSinceEpoch}',
        'no_antrian': 'A-01',
        'redirect_url': '',
        'status_pembayaran': 'lunas',
        'is_lunas': true,
        'total': 50000,
      };
    }

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

  // 8. Check Payment Status (for polling)
  Future<Map<String, dynamic>?> checkPaymentStatus(String noPemeriksaan) async {
    if (AppConfig.demoMode) {
      return {
        'no_pemeriksaan': noPemeriksaan,
        'no_antrian': 'A-01',
        'status_pembayaran': 'lunas',
        'is_lunas': true,
        'total': 50000,
      };
    }

    final url = Uri.parse(ApiEndpoint.cekStatusPembayaran(noPemeriksaan)); // Updated to match Laravel route (param: {id})
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