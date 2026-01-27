class BiayaLayananModel {
  final int id;
  final String tipeLayanan;
  final String jenisPasien;
  final int biayaReservasi;
  final DateTime createdAt;
  final DateTime updatedAt;

  BiayaLayananModel({
    required this.id,
    required this.tipeLayanan,
    required this.jenisPasien,
    required this.biayaReservasi,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BiayaLayananModel.fromJson(Map<String, dynamic> json) {
    return BiayaLayananModel(
      id: json['id'] ?? 0,
      tipeLayanan: json['tipe_layanan'] ?? '',
      jenisPasien: json['jenis_pasien'] ?? '',
      biayaReservasi: json['biaya_reservasi'] != null
          ? (double.tryParse(json['biaya_reservasi'].toString()) ?? 0).toInt()
          : 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipe_layanan': tipeLayanan,
      'jenis_pasien': jenisPasien,
      'biaya_reservasi': biayaReservasi,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}