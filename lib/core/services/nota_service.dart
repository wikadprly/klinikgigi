import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nota_model.dart';
import '../../config/app_config.dart';

class InvoiceService {
  static const String baseUrl = AppConfig.apiBaseUrl;

  Future<InvoiceModel> getInvoice(int idTransaksi) async {
    if (AppConfig.demoMode) {
      return InvoiceModel(
        invoiceId: 'INV-DEMO-$idTransaksi',
        namaPasien: 'Pasien Demo',
        tanggal: DateTime.now().toString().split(' ').first,
        items: [
          InvoiceItem(nama: 'Pemeriksaan Gigi', harga: 100000),
          InvoiceItem(nama: 'Scaling', harga: 150000),
        ],
        subtotal: 250000,
        booking: 50000,
        totalAkhir: 200000,
      );
    }

    final res = await http.get(Uri.parse("$baseUrl/nota/$idTransaksi"));

    if (res.statusCode == 200) {
      return InvoiceModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Gagal memuat data invoice");
    }
  }

  Future<bool> bayar(int idTransaksi, String metode) async {
    if (AppConfig.demoMode) return true;

    final res = await http.post(
      Uri.parse("$baseUrl/nota/$idTransaksi/pelunasan"),
      body: {"metode": metode},
    );

    return res.statusCode == 200;
  }
}
