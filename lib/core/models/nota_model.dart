class NotaPelunasanModel {
  final String invoiceId;
  final String noPemeriksaan;
  final String pasienId;
  final String namaPasien;
  final String email;
  final String phone;
  final String tanggal;
  final List<ItemPelarwatan> itemPerawatan;
  final double subtotal;
  final double uangBooking;
  final double totalAkhir;
  final String metodePembayaran;
  final String statusPembayaran;
  final String? bankTransaksiId;
  final String? nomorReferensi;
  final DateTime? tanggalPembayaran;

  NotaPelunasanModel({
    required this.invoiceId,
    required this.noPemeriksaan,
    required this.pasienId,
    required this.namaPasien,
    required this.email,
    required this.phone,
    required this.tanggal,
    required this.itemPerawatan,
    required this.subtotal,
    required this.uangBooking,
    required this.totalAkhir,
    required this.metodePembayaran,
    required this.statusPembayaran,
    this.bankTransaksiId,
    this.nomorReferensi,
    this.tanggalPembayaran,
  });

  factory NotaPelunasanModel.fromJson(Map<String, dynamic> json) {
    return NotaPelunasanModel(
      invoiceId: json['invoice_id'] ?? '',
      noPemeriksaan: json['no_pemeriksaan'] ?? '',
      pasienId: json['pasien_id'] ?? '',
      namaPasien: json['nama_pasien'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      tanggal: json['tanggal'] ?? '',
      itemPerawatan: (json['item_perawatan'] as List<dynamic>?)
              ?.map((item) => ItemPelarwatan.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      uangBooking: (json['uang_booking'] as num?)?.toDouble() ?? 0.0,
      totalAkhir: (json['total_akhir'] as num?)?.toDouble() ?? 0.0,
      metodePembayaran: json['metode_pembayaran'] ?? '',
      statusPembayaran: json['status_pembayaran'] ?? '',
      bankTransaksiId: json['bank_transaksi_id'],
      nomorReferensi: json['nomor_referensi'],
      tanggalPembayaran: json['tanggal_pembayaran'] != null
          ? DateTime.parse(json['tanggal_pembayaran'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'invoice_id': invoiceId,
        'no_pemeriksaan': noPemeriksaan,
        'pasien_id': pasienId,
        'nama_pasien': namaPasien,
        'email': email,
        'phone': phone,
        'tanggal': tanggal,
        'item_perawatan': itemPerawatan.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'uang_booking': uangBooking,
        'total_akhir': totalAkhir,
        'metode_pembayaran': metodePembayaran,
        'status_pembayaran': statusPembayaran,
        'bank_transaksi_id': bankTransaksiId,
        'nomor_referensi': nomorReferensi,
        'tanggal_pembayaran': tanggalPembayaran?.toIso8601String(),
      };
}

class ItemPelarwatan {
  final String id;
  final String namaPerawatan;
  final double harga;
  final int jumlah;
  final double total;

  ItemPelarwatan({
    required this.id,
    required this.namaPerawatan,
    required this.harga,
    required this.jumlah,
    required this.total,
  });

  factory ItemPelarwatan.fromJson(Map<String, dynamic> json) {
    return ItemPelarwatan(
      id: json['id'] ?? '',
      namaPerawatan: json['nama_perawatan'] ?? '',
      harga: (json['harga'] as num?)?.toDouble() ?? 0.0,
      jumlah: json['jumlah'] as int? ?? 1,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama_perawatan': namaPerawatan,
        'harga': harga,
        'jumlah': jumlah,
        'total': total,
      };
}
