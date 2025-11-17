class DokterModel {
  final int id;
  final String namaDokter;
  final String spesialisasi;
  final String? fotoProfil;

  DokterModel({
    required this.id,
    required this.namaDokter,
    required this.spesialisasi,
    this.fotoProfil,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(
      id: json['dokter_id'] is String
          ? int.tryParse(json['dokter_id'].toString()) ?? 0
          : json['dokter_id'] ?? 0,

      namaDokter: json['nama_dokter']?.toString() ?? '',
      spesialisasi: json['spesialisasi']?.toString() ?? '',
      fotoProfil: json['foto_profil']?.toString(),
    );
  }
}
