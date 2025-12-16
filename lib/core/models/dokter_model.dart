import 'package:flutter_klinik_gigi/core/models/jadwal_praktek_model.dart'; // Import JadwalPraktek yang benar

class DokterModel {
  final int id;
  final String namaDokter;
  final String spesialisasi;
  final String? fotoProfil;

  // Menggunakan tipe List<JadwalPraktek> yang diimpor
  final List<JadwalPraktek> jadwal;

  DokterModel({
    required this.id,
    required this.namaDokter,
    required this.spesialisasi,
    this.fotoProfil,
    required this.jadwal,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(
      id: json['dokter_id'] is String
          ? int.tryParse(json['dokter_id'].toString()) ?? 0
          : json['dokter_id'] ?? 0,

      namaDokter: json['nama_dokter']?.toString() ?? '',
      spesialisasi: json['spesialisasi']?.toString() ?? '',
      fotoProfil: json['foto_profil']?.toString(),

      // convert jadwal list
      jadwal: (json['jadwal'] as List<dynamic>? ?? [])
          .map((j) => JadwalPraktek.fromJson(j)) // Menggunakan JadwalPraktek
          .toList(),
    );
  }
}
