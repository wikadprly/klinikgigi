class DokterModel {
  final int dokterId;
  final String namaDokter;
  final String spesialisasi;
  final String? fotoProfil; // Path atau URL foto, bisa null

  DokterModel({
    required this.dokterId,
    required this.namaDokter,
    required this.spesialisasi,
    this.fotoProfil,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(
      // INI DARI VERSI HEAD (kamu)
      // Karena 'dokterId' di class ini tipenya 'int'
      dokterId: json['dokter_id'],

      // INI DARI VERSI 'main' (lebih aman handle data null)
      namaDokter: json['nama_dokter'] ?? '',
      spesialisasi: json['spesialisasi'] ?? '',

      // Ini sama di kedua versi, aman
      fotoProfil: json['foto_profil'],
    );
  }
}