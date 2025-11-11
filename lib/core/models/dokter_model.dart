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
<<<<<<< HEAD
      dokterId: json['dokter_id'],
      namaDokter: json['nama_dokter'],
      spesialisasi: json['spesialisasi'],
=======
      dokterId: json['dokter_id'].toString(),

      // Jika 'nama_dokter' null, gunakan string kosong ''
      namaDokter: json['nama_dokter'] ?? '',

      // Jika 'spesialisasi' null, gunakan string kosong ''
      spesialisasi: json['spesialisasi'] ?? '',

      // fotoProfil sudah aman karena tipenya String? (nullable)
>>>>>>> cb9a1c9 (update: Memperbarui logika dari model dokter)
      fotoProfil: json['foto_profil'],
    );
  }
}
