// Untuk di Halaman Dokter
// Untuk di Halaman Dokter

import 'master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';

class DokterDetailModel {
  final int id;
  final String? nama;
  final String? foto;
  final String? spesialisasi;
  final MasterPoliModel? masterPoli;
  final List<MasterJadwalModel>? masterJadwal;

  DokterDetailModel({
    required this.id,
    this.nama,
    this.foto,
    this.spesialisasi,
    this.masterPoli,
    this.masterJadwal,
  });

  factory DokterDetailModel.fromJson(Map<String, dynamic> json) {
    return DokterDetailModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,

      nama: json['nama']?.toString(),
      foto: json['foto']?.toString(),
      spesialisasi: json['spesialisasi']?.toString(),

      masterPoli: (json['masterPoli'] is Map)
          ? MasterPoliModel.fromJson(
              Map<String, dynamic>.from(json['masterPoli']),
            )
          : null,

      masterJadwal: (json['masterJadwal'] is List)
          ? List<MasterJadwalModel>.from(
              (json['masterJadwal'] as List).map(
                (x) => MasterJadwalModel.fromJson(Map<String, dynamic>.from(x)),
              ),
            )
          : [],
    );
  }
}
