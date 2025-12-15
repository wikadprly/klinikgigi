import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nota_model.dart';

class InvoiceService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<InvoiceModel> getInvoice(int idTransaksi) async {
    final res = await http.get(Uri.parse("$baseUrl/nota/$idTransaksi"));

    if (res.statusCode == 200) {
      return InvoiceModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Gagal memuat data invoice");
    }
  }

  Future<bool> bayar(int idTransaksi, String metode) async {
    final res = await http.post(
      Uri.parse("$baseUrl/nota/$idTransaksi/pelunasan"),
      body: {"metode": metode},
    );

    return res.statusCode == 200;
  }
}
