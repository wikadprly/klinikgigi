class HomeCareBooking {
  final int id;
  final String noPemeriksaan;
  final String? noAntrian;
  final String pasienId;
  final String? dokterId;
  final int? jadwalId;
  final String tanggalPesan;
  final String? waktuPesan;
  final double? biayaTransport;
  final double? biayaReservasi;
  final double? pembayaranTotal;
  final String? metodePembayaran;
  final String? statusPembayaran;

  HomeCareBooking({
    required this.id,
    required this.noPemeriksaan,
    required this.pasienId,
    required this.tanggalPesan,
    this.noAntrian,
    this.dokterId,
    this.jadwalId,
    this.waktuPesan,
    this.biayaTransport,
    this.biayaReservasi,
    this.pembayaranTotal,
    this.metodePembayaran,
    this.statusPembayaran,
  });

  factory HomeCareBooking.fromJson(Map<String, dynamic> json) {
    return HomeCareBooking(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      noPemeriksaan: json['no_pemeriksaan'] ?? '',
      noAntrian: json['no_antrian'],
      pasienId: json['pasien_id']?.toString() ?? '',
      dokterId: json['dokter_id']?.toString(),
      jadwalId: json['jadwal_id'] is int
          ? json['jadwal_id']
          : int.tryParse('${json['jadwal_id']}'),
      tanggalPesan: json['tanggal_pesan'] ?? '',
      waktuPesan: json['waktu_pesan'],
      biayaTransport: json['biaya_transport'] != null
          ? (json['biaya_transport'] as num).toDouble()
          : null,
      biayaReservasi: json['biaya_reservasi'] != null
          ? (json['biaya_reservasi'] as num).toDouble()
          : null,
      pembayaranTotal: json['pembayaran_total'] != null
          ? (json['pembayaran_total'] as num).toDouble()
          : null,
      metodePembayaran: json['metode_pembayaran'],
      statusPembayaran: json['status_pembayaran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_pemeriksaan': noPemeriksaan,
      'no_antrian': noAntrian,
      'pasien_id': pasienId,
      'dokter_id': dokterId,
      'jadwal_id': jadwalId,
      'tanggal_pesan': tanggalPesan,
      'waktu_pesan': waktuPesan,
      'biaya_transport': biayaTransport,
      'biaya_reservasi': biayaReservasi,
      'pembayaran_total': pembayaranTotal,
      'metode_pembayaran': metodePembayaran,
      'status_pembayaran': statusPembayaran,
    };
  }
}