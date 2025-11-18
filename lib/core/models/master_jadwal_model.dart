// lib/core/models/master_jadwal_model.dart

class MasterJadwalModel {
  final int jadwalId;
  final String kodeDokter;
  final String namaDokter;
  final String kodePoli;
  final String namaPoli;
  final String hari;         // ⬅⬅⬅ TAMBAHKAN INI
  final String jamMulai;
  final String jamSelesai;
  final int kuotaTotal;
  final int kuotaTerpakai;
  final int sisaKuota;

  MasterJadwalModel({
    required this.jadwalId,
    required this.kodeDokter,
    required this.namaDokter,
    required this.kodePoli,
    required this.namaPoli,
    required this.hari,        // ⬅⬅ TAMBAHKAN INI
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuotaTotal,
    required this.kuotaTerpakai,
    required this.sisaKuota,
  });

  factory MasterJadwalModel.fromJson(Map<String, dynamic> json) {
    return MasterJadwalModel(
      jadwalId: json['jadwal_id'] ?? 0,
      kodeDokter: json['kode_dokter'] ?? '',
      namaDokter: json['nama_dokter'] ?? '',
      kodePoli: json['kode_poli'] ?? '',
      namaPoli: json['nama_poli'] ?? '',
      hari: json['hari'] ?? '-',                 // ⬅⬅⬅ BACA DARI API
      jamMulai: json['jam_mulai'] ?? '',
      jamSelesai: json['jam_selesai'] ?? '',
      kuotaTotal: json['kuota_total'] ?? 0,
      kuotaTerpakai: json['kuota_terpakai'] ?? 0,
      sisaKuota: json['sisa_kuota'] ?? 0,
    );
  }
}
