import 'package:flutter/material.dart';
import '../core/models/nota_model.dart';
import '../core/services/nota_service.dart';

class InvoiceProvider extends ChangeNotifier {
  InvoiceModel? invoice;
  bool loading = false;
  String metodePembayaran = "Tunai";

  final InvoiceService _service = InvoiceService();

  Future<void> loadInvoice(int idTransaksi) async {
    loading = true;
    notifyListeners();

    invoice = await _service.getInvoice(idTransaksi);

    loading = false;
    notifyListeners();
  }

  Future<bool> bayar(int idTransaksi) async {
    return await _service.bayar(idTransaksi, metodePembayaran);
  }

  void setMetode(String metode) {
    metodePembayaran = metode;
    notifyListeners();
  }
}
