// lib/core/models/master_dokter_model.dart

class MasterDokterModel {
  final String kodeDokter;
  final String kodePoli;
  final String nama;
  final String gelar;
  final String spesialisasi;
  final String alamat;
  final String hp;
  final String tipe;
  final String dokterStr;
  final String dokterStrMulai;
  final String dokterStrExpire;
  final String dokterSip;
  final String dokterSipBerlaku;
  final String dokterSipExpired;
  final String inisial;

  MasterDokterModel({
    required this.kodeDokter,
    required this.kodePoli,
    required this.nama,
    required this.gelar,
    required this.spesialisasi,
    required this.alamat,
    required this.hp,
    required this.tipe,
    required this.dokterStr,
    required this.dokterStrMulai,
    required this.dokterStrExpire,
    required this.dokterSip,
    required this.dokterSipBerlaku,
    required this.dokterSipExpired,
    required this.inisial,
  });

  factory MasterDokterModel.fromJson(Map<String, dynamic> json) {
    return MasterDokterModel(
      kodeDokter: json['kode_dokter'] ?? '',
      kodePoli: json['kode_poli'] ?? '',
      nama: json['nama'] ?? '',
      gelar: json['gelar'] ?? '',
      spesialisasi: json['spesialisasi'] ?? '',
      alamat: json['alamat'] ?? '',
      hp: json['hp'] ?? '',
      tipe: json['tipe'] ?? '',
      dokterStr: json['dokter_str'] ?? '',
      dokterStrMulai: json['dokter_str_mulai'] ?? '',
      dokterStrExpire: json['dokter_str_expire'] ?? '',
      dokterSip: json['dokter_sip'] ?? '',
      dokterSipBerlaku: json['dokter_sip_berlaku'] ?? '',
      dokterSipExpired: json['dokter_sip_expired'] ?? '',
      inisial: json['inisial'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_dokter': kodeDokter,
      'kode_poli': kodePoli,
      'nama': nama,
      'gelar': gelar,
      'spesialisasi': spesialisasi,
      'alamat': alamat,
      'hp': hp,
      'tipe': tipe,
      'dokter_str': dokterStr,
      'dokter_str_mulai': dokterStrMulai,
      'dokter_str_expire': dokterStrExpire,
      'dokter_sip': dokterSip,
      'dokter_sip_berlaku': dokterSipBerlaku,
      'dokter_sip_expired': dokterSipExpired,
      'inisial': inisial,
    };
  }
  @override
  String toString() => gelar != null && gelar!.isNotEmpty
      ? '$nama, $gelar'
      : nama;

}
