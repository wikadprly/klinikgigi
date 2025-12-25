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
  final String? foto;
  final String? poliNama; // Added field

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
    this.foto,
    this.poliNama,
  });

  String get namaLengkap => gelar.isNotEmpty ? '$nama, $gelar' : nama;

  factory MasterDokterModel.fromJson(Map<String, dynamic> json) {
    // Logic untuk inisial jika backend tidak mengirim property 'inisial'
    String namaRaw = json['nama'] ?? json['nama_dokter'] ?? '';
    String inisialCalc = json['inisial'] ?? '';
    if (inisialCalc.isEmpty && namaRaw.isNotEmpty) {
      var parts = namaRaw.trim().split(' ');
      if (parts.length >= 2) {
        inisialCalc = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty) {
        inisialCalc = parts[0][0].toUpperCase();
      }
    }

    return MasterDokterModel(
      kodeDokter: json['kode_dokter'] ?? json['dokter_id']?.toString() ?? '',
      kodePoli: json['kode_poli'] ?? '',
      nama: namaRaw,
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
      inisial: inisialCalc,
      foto: json['foto_profil'],
      poliNama: json['poli_nama'] ?? '',
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
      'poli_nama': poliNama,
    };
  }

  @override
  String toString() => namaLengkap;
}
