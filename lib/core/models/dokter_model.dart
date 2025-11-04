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
      dokterId: json['dokter_id'],
      namaDokter: json['nama_dokter'],
      spesialisasi: json['spesialisasi'],
      fotoProfil: json['foto_profil'],
    );
  }
}
