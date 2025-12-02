import 'package:flutter/foundation.dart';
import 'package:flutter_klinik_gigi/core/models/nota_model.dart';
import 'package:flutter_klinik_gigi/core/models/treatment_item.dart';
import 'package:flutter_klinik_gigi/core/services/payment_service.dart';
import 'package:flutter_klinik_gigi/core/services/rincian_service.dart';


class PaymentProvider extends ChangeNotifier {
late PaymentService _service;
bool isLoading = false;
String paymentMethod = 'Transfer';
late InvoiceModel invoice;


PaymentProvider() {
// point to your real API base url
final api = ApiService(baseUrl: 'http://127.0.0.1:8000/api');
_service = PaymentService(api: api);


// sample invoice (in real app fetch from API)
invoice = InvoiceModel(
patientName: 'Fareliooooo',
invoiceId: '#INV-3K-231024-001',
date: DateTime(2025, 11, 3),
items: [
TreatmentItem(name: 'Scaling Gigi', price: 500000),
TreatmentItem(name: 'Tambal Komposit', price: 750000),
],
bookingDiscount: 25000,
points: 800,
);
}


void setMethod(String method) {
paymentMethod = method;
notifyListeners();
}


Future<bool> pay() async {
isLoading = true;
notifyListeners();
try {
final success = await _service.pay(invoice, paymentMethod);
isLoading = false;
notifyListeners();
return success;
} catch (e) {
isLoading = false;
notifyListeners();
rethrow;
}
}
}