class DokterModel {
  final String dokterId;
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
      dokterId: json['dokter_id'].toString(),

      // Jika 'nama_dokter' null, gunakan string kosong ''
      namaDokter: json['nama_dokter'] ?? '',

      // Jika 'spesialisasi' null, gunakan string kosong ''
      spesialisasi: json['spesialisasi'] ?? '',

      // fotoProfil sudah aman karena tipenya String? (nullable)
      fotoProfil: json['foto_profil'],
    );
  }
}
