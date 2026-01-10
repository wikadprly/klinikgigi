class MasterJadwalModel {
  final int id;
  final String kodeDokter;
  final String kodePoli;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String keterangan;
  final int quota;        // Kuota Total (Master)
  final int kuotaTerpakai;
  final int sisaKuota;
  final String statusJadwal; // 'Tersedia', 'Penuh', 'Libur'
  final String? tanggalPilih; // Untuk validasi tanggal yang dipilih user
  final String? tanggalJadwalHarian; // Tanggal aktual dari jadwal_harian

  MasterJadwalModel({
    required this.id,
    required this.kodeDokter,
    required this.kodePoli,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.keterangan,
    required this.quota,
    this.kuotaTerpakai = 0,

    // Default values agar tidak error jika null
    this.sisaKuota = 0,
    this.statusJadwal = 'Tersedia',
    this.tanggalPilih,
    this.tanggalJadwalHarian,
  });

  factory MasterJadwalModel.fromJson(Map<String, dynamic> json) {
    return MasterJadwalModel(
      id: json['jadwal_id'] != null
          ? (json['jadwal_id'] is String ? int.parse(json['jadwal_id']) : json['jadwal_id'])
          : (json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0),
      kodeDokter: json['kode_dokter']?.toString() ?? '',
      kodePoli: json['kode_poli']?.toString() ?? '',
      hari: json['hari']?.toString() ?? '',
      jamMulai: json['jam_mulai']?.toString() ?? '',
      jamSelesai: json['jam_selesai']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '-',

      // Parsing Angka yang Aman
      quota: int.tryParse(json['kuota_total']?.toString() ?? json['quota']?.toString() ?? '0') ?? 0,
      kuotaTerpakai: int.tryParse(json['kuota_terpakai']?.toString() ?? '0') ?? 0,

      // 🔥 MENGAMBIL DATA SISA & STATUS
      sisaKuota: int.tryParse(json['sisa_kuota']?.toString() ?? '0') ?? 0,
      statusJadwal: json['status_jadwal']?.toString() ?? 'Tersedia',
      tanggalPilih: json['tanggal_pilih']?.toString(),
      tanggalJadwalHarian: json['tanggal_jadwal_harian']?.toString(), // Tambahkan field baru
    );
  }

  // Helper untuk cek apakah bisa dibooking
  bool get isAvailable => statusJadwal == 'Tersedia' && sisaKuota > 0;
}