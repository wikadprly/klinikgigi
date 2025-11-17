// Untuk di Halaman Dokter
// Untuk di Halaman Dokter

import 'master_jadwal_model.dart';
import 'package:flutter_klinik_gigi/core/models/master_poli_model.dart';

class MasterDokterModel {
  final int id;
  final String? nama;
  final String? foto;
  final String? spesialisasi;
  final MasterPoliModel? masterPoli;
  final List<MasterJadwalModel>?
  masterJadwal; // Tipe data (Nama Class) ini benar

  MasterDokterModel({
    required this.id,
    this.nama,
    this.foto,
    this.spesialisasi,
    this.masterPoli,
    this.masterJadwal,
  });

  factory MasterDokterModel.fromJson(Map<String, dynamic> json) {
    return MasterDokterModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,

      nama: json['nama']?.toString(),
      foto: json['foto']?.toString(),
      spesialisasi: json['spesialisasi']?.toString(),

      masterPoli: json['masterPoli'] != null
          ? MasterPoliModel.fromJson(json['masterPoli'])
          : null,

      // Pemanggilan class 'MasterJadwalModel' ini sudah benar.
      // Error sebelumnya terjadi karena import di baris 1 gagal.
      masterJadwal: json['masterJadwal'] != null
          ? List<MasterJadwalModel>.from(
              json['masterJadwal'].map((x) => MasterJadwalModel.fromJson(x)),
            )
          : [],
    );
  }
}
