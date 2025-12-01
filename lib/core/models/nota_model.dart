class InvoiceItem {
  final String nama;
  final int harga;

  InvoiceItem({
    required this.nama,
    required this.harga,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      nama: json['namaPerawatan'],
      harga: json['harga'],
    );
  }
}

class InvoiceModel {
  final String namaPasien;
  final String invoiceId;
  final String tanggal;
  final int subtotal;
  final int booking;
  final int totalAkhir;
  final List<InvoiceItem> items;

  InvoiceModel({
    required this.namaPasien,
    required this.invoiceId,
    required this.tanggal,
    required this.subtotal,
    required this.booking,
    required this.totalAkhir,
    required this.items,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      namaPasien: json['namaPasien'],
      invoiceId: json['invoiceId'],
      tanggal: json['tanggal'],
      subtotal: json['subtotal'],
      booking: json['uangBooking'],
      totalAkhir: json['totalAkhir'],
      items: (json['rincian'] as List)
          .map((e) => InvoiceItem.fromJson(e))
          .toList(),
    );
  }
}
