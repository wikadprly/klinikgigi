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

  // [BARU] Field untuk Midtrans
  final String? snapToken;
  final String? redirectUrl;

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
    // [BARU] Tambahkan di constructor
    this.snapToken,
    this.redirectUrl,
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

      // [BARU] Mapping dari JSON Database/API
      snapToken: json['snap_token'],
      redirectUrl: json['redirect_url'],
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
      // [BARU] Sertakan saat convert ke JSON
      'snap_token': snapToken,
      'redirect_url': redirectUrl,
    };
  }
}

// [BARU] Helper Class untuk mem-parsing response lengkap dari Controller Laravel
// Struktur: { "message": "...", "data": {...}, "payment_info": {...} }
class HomeCareBookingResponse {
  final String? message;
  final HomeCareBooking? data;
  final PaymentInfo? paymentInfo;

  HomeCareBookingResponse({this.message, this.data, this.paymentInfo});

  factory HomeCareBookingResponse.fromJson(Map<String, dynamic> json) {
    return HomeCareBookingResponse(
      message: json['message'],
      data: json['data'] != null
          ? HomeCareBooking.fromJson(json['data'])
          : null,
      paymentInfo: json['payment_info'] != null
          ? PaymentInfo.fromJson(json['payment_info'])
          : null,
    );
  }
}

class PaymentInfo {
  final String? snapToken;
  final String? redirectUrl;
  final dynamic amount;

  PaymentInfo({this.snapToken, this.redirectUrl, this.amount});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      snapToken: json['snap_token'],
      redirectUrl: json['redirect_url'],
      amount: json['amount'],
    );
  }
}
