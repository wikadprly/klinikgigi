class RiwayatModel {
  final String noPemeriksaan;
  final String dokter;
  final String tanggal;
  final String poli;
  final String status;

  RiwayatModel({
    required this.noPemeriksaan,
    required this.dokter,
    required this.tanggal,
    required this.poli,
    required this.status,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      noPemeriksaan: json['no_pemeriksaan'] ?? '-',
      dokter: json['dokter'] ?? '-',
      tanggal: json['tanggal'] ?? '-',
      poli: json['poli'] ?? '-',
      status: json['status_reservasi'] ?? '-',
    );
  }
}
