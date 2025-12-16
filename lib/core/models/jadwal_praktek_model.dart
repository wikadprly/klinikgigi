// File: lib/core/models/jadwal_praktek_model.dart

class JadwalPraktek {
  final String hari;
  final String jamMulai;
  final String jamSelesai;

  JadwalPraktek({
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });

  factory JadwalPraktek.fromJson(Map<String, dynamic> json) {
    return JadwalPraktek(
      hari: json['hari']?.toString() ?? '',
      jamMulai: json['jam_mulai']?.toString() ?? '',
      jamSelesai: json['jam_selesai']?.toString() ?? '',
    );
  }
}
