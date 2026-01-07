class ReservasiModel {
  final String noPemeriksaan;
  final String noAntrian;
  final String pasienId;
  final String dokterId;
  final int jadwalId;
  final String tanggalPesan;
  final String waktuPesan;
  final String jamMulai;
  final String jamSelesai;
  final String keluhan;
  final int biayaReservasi;
  final String status;
  final String statusReservasi;
  final String metodePembayaran;
  final String statusPembayaran;
  final String? bankTransaksiId;
  final int pembayaranTotal;
  final String jenisPasien;

  final Map<String, dynamic>? pasien;
  final Map<String, dynamic>? dokter;
  final Map<String, dynamic>? jadwal;

  ReservasiModel({
    required this.noPemeriksaan,
    this.noAntrian = '-', //
    required this.pasienId,
    required this.dokterId,
    required this.jadwalId,
    required this.tanggalPesan,
    required this.waktuPesan,
    required this.jamMulai,
    required this.jamSelesai,
    required this.keluhan,
    required this.biayaReservasi,
    required this.status,
    required this.statusReservasi,
    required this.metodePembayaran,
    required this.statusPembayaran,
    this.bankTransaksiId,
    required this.pembayaranTotal,
    required this.jenisPasien,
    this.pasien,
    this.dokter,
    this.jadwal,
  });

  factory ReservasiModel.fromJson(Map<String, dynamic> json) {
    return ReservasiModel(
      noPemeriksaan: json['no_pemeriksaan'] ?? '',
      // 🔥 Tangkap data dari Backend disini
      noAntrian: json['no_antrian']?.toString() ?? '-',

      pasienId: json['pasien_id'] ?? '',
      dokterId: json['dokter_id'] ?? '',
      jadwalId: json['jadwal_id'] ?? 0,
      tanggalPesan: json['tanggal_pesan'] ?? '',
      waktuPesan: json['waktu_pesan'] ?? '',
      jamMulai: json['jam_mulai'] ?? '',
      jamSelesai: json['jam_selesai'] ?? '',
      keluhan: json['keluhan'] ?? '',
      biayaReservasi: json['biaya_reservasi'] != null
          ? (double.tryParse(json['biaya_reservasi'].toString()) ?? 0).toInt()
          : 0,
      status: json['status'] ?? '',
      statusReservasi: json['status_reservasi'] ?? '',
      metodePembayaran: json['metode_pembayaran'] ?? '',
      statusPembayaran: json['status_pembayaran'] ?? '',
      bankTransaksiId: json['bank_transaksi_id'],
      pembayaranTotal: json['pembayaran_total'] != null
          ? (double.tryParse(json['pembayaran_total'].toString()) ?? 0).toInt()
          : 0,
      jenisPasien: json['jenis_pasien'] ?? '',
      pasien: json['pasien'],
      dokter: json['dokter'],
      jadwal: json['jadwal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_pemeriksaan': noPemeriksaan,
      'no_antrian': noAntrian, //
      'pasien_id': pasienId,
      'dokter_id': dokterId,
      'jadwal_id': jadwalId,
      'tanggal_pesan': tanggalPesan,
      'waktu_pesan': waktuPesan,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'keluhan': keluhan,
      'biaya_reservasi': biayaReservasi,
      'status': status,
      'status_reservasi': statusReservasi,
      'metode_pembayaran': metodePembayaran,
      'status_pembayaran': statusPembayaran,
      'bank_transaksi_id': bankTransaksiId,
      'pembayaran_total': pembayaranTotal,
      'jenis_pasien': jenisPasien,
      'pasien': pasien,
      'dokter': dokter,
      'jadwal': jadwal,
    };
  }
}
