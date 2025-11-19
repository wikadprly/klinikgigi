// lib/core/models/master_jadwalmodel.dart

class MasterJadwalModel {
  final int id;
  final String kodeDokter;
  final String kodePoli;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String keterangan;
  final int quota;

  MasterJadwalModel({
    required this.id,
    required this.kodeDokter,
    required this.kodePoli,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.keterangan,
    required this.quota,
  });

  factory MasterJadwalModel.fromJson(Map<String, dynamic> json) {
    return MasterJadwalModel(
      id: json['id'] is String
          ? int.tryParse(json['id']) ?? 0
          : json['id'] ?? 0,
      kodeDokter: json['kode_dokter']?.toString() ?? '',
      kodePoli: json['kode_poli']?.toString() ?? '',
      hari: json['hari']?.toString() ?? '',
      jamMulai: json['jam_mulai']?.toString() ?? '',
      jamSelesai: json['jam_selesai']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
      quota: json['quota'] is String
          ? int.tryParse(json['quota']) ?? 0
          : json['quota'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_dokter': kodeDokter,
      'kode_poli': kodePoli,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'keterangan': keterangan,
      'quota': quota,
    };
  }
}
