import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api.dart';
import '../../config/app_config.dart';
import '../models/master_dokter_model.dart';
import '../models/master_jadwal_model.dart';
import '../models/master_poli_model.dart';
import '../models/dokter_detail_model.dart';

class DokterService {
  final String _url = ApiEndpoint.dokter;

  static final List<MasterDokterModel> _demoDokter = [
    MasterDokterModel(
      kodeDokter: 'DOK-01',
      kodePoli: 'POL-01',
      nama: 'drg. Bagus Pratama',
      gelar: '',
      spesialisasi: 'Dokter Gigi Umum',
      alamat: 'Jl. Kesehatan No. 1, Semarang',
      hp: '081234567801',
      tipe: 'Umum',
      dokterStr: 'SIP-001',
      dokterStrMulai: '2020-01-01',
      dokterStrExpire: '2025-01-01',
      dokterSip: 'SIP-001',
      dokterSipBerlaku: '2020-01-01',
      dokterSipExpired: '2025-01-01',
      inisial: 'BP',
      poliNama: 'Poli Gigi Umum',
    ),
    MasterDokterModel(
      kodeDokter: 'DOK-02',
      kodePoli: 'POL-01',
      nama: 'drg. Ayu Lestari',
      gelar: '',
      spesialisasi: 'Dokter Gigi Umum',
      alamat: 'Jl. Kesehatan No. 1, Semarang',
      hp: '081234567802',
      tipe: 'Umum',
      dokterStr: 'SIP-002',
      dokterStrMulai: '2020-01-01',
      dokterStrExpire: '2025-01-01',
      dokterSip: 'SIP-002',
      dokterSipBerlaku: '2020-01-01',
      dokterSipExpired: '2025-01-01',
      inisial: 'AL',
      poliNama: 'Poli Gigi Umum',
    ),
    MasterDokterModel(
      kodeDokter: 'DOK-03',
      kodePoli: 'POL-02',
      nama: 'drg. Citra Dewi',
      gelar: 'Sp.Ort',
      spesialisasi: 'Ortodonti',
      alamat: 'Jl. Kesehatan No. 1, Semarang',
      hp: '081234567803',
      tipe: 'Spesialis',
      dokterStr: 'SIP-003',
      dokterStrMulai: '2020-01-01',
      dokterStrExpire: '2025-01-01',
      dokterSip: 'SIP-003',
      dokterSipBerlaku: '2020-01-01',
      dokterSipExpired: '2025-01-01',
      inisial: 'CD',
      poliNama: 'Poli Ortodonti',
    ),
    MasterDokterModel(
      kodeDokter: 'DOK-04',
      kodePoli: 'POL-03',
      nama: 'drg. Dimas Saputra',
      gelar: 'Sp.BM',
      spesialisasi: 'Bedah Mulut',
      alamat: 'Jl. Kesehatan No. 1, Semarang',
      hp: '081234567804',
      tipe: 'Spesialis',
      dokterStr: 'SIP-004',
      dokterStrMulai: '2020-01-01',
      dokterStrExpire: '2025-01-01',
      dokterSip: 'SIP-004',
      dokterSipBerlaku: '2020-01-01',
      dokterSipExpired: '2025-01-01',
      inisial: 'DS',
      poliNama: 'Poli Bedah Mulut',
    ),
  ];

  // --- METHOD UNTUK DAFTAR DOKTER ---
  Future<List<MasterDokterModel>> fetchDokter([String? search]) async {
    if (AppConfig.demoMode) {
      if (search == null || search.isEmpty) {
        return List<MasterDokterModel>.from(_demoDokter);
      }
      final keyword = search.toLowerCase();
      return _demoDokter
          .where(
            (d) =>
                d.nama.toLowerCase().contains(keyword) ||
                d.spesialisasi.toLowerCase().contains(keyword),
          )
          .toList();
    }

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
  Future<DokterDetailModel> fetchDokterDetail(String id) async {
    if (AppConfig.demoMode) {
      final dokter = _demoDokter.firstWhere(
        (d) => d.kodeDokter == id,
        orElse: () => _demoDokter.first,
      );
      final poli = MasterPoliModel(
        kodePoli: dokter.kodePoli,
        namaPoli: dokter.poliNama ?? 'Poli Gigi',
        keterangan: 'Pelayanan ${dokter.spesialisasi}',
      );

      return DokterDetailModel(
        id: int.tryParse(dokter.kodeDokter.split('-').last) ?? 1,
        nama: dokter.namaLengkap,
        foto: null,
        spesialisasi: dokter.spesialisasi,
        masterPoli: poli,
        masterJadwal: [
          MasterJadwalModel(
            id: 101,
            kodeDokter: dokter.kodeDokter,
            kodePoli: dokter.kodePoli,
            hari: 'Senin',
            jamMulai: '09:00',
            jamSelesai: '12:00',
            keterangan: 'Praktek pagi',
            quota: 8,
            kuotaTerpakai: 3,
            sisaKuota: 5,
          ),
          MasterJadwalModel(
            id: 102,
            kodeDokter: dokter.kodeDokter,
            kodePoli: dokter.kodePoli,
            hari: 'Rabu',
            jamMulai: '13:00',
            jamSelesai: '16:00',
            keterangan: 'Praktek siang',
            quota: 8,
            kuotaTerpakai: 2,
            sisaKuota: 6,
          ),
        ],
      );
    }

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
