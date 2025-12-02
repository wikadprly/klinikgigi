import 'dart:convert';
import 'package:flutter_klinik_gigi/core/models/treatment_item.dart';
import 'package:http/http.dart' as http;
import '../models/nota_model.dart';


class ApiService {
final String baseUrl;
ApiService({required this.baseUrl});


// Example: fetch invoice by id
Future<InvoiceModel> fetchInvoice(String id) async {
final uri = Uri.parse('\$baseUrl/invoice/\$id');
final res = await http.get(uri).timeout(const Duration(seconds: 10));
if (res.statusCode == 200) {
final data = jsonDecode(res.body);
// adapt to your API shape
return InvoiceModel(
patientName: data['patient_name'],
invoiceId: data['invoice_id'],
date: DateTime.parse(data['date']),
bookingDiscount: data['booking_discount'] ?? 0,
points: data['points'] ?? 0,
items: (data['items'] as List).map((it) =>
// ensure fields exist
TreatmentItem(name: it['name'], price: it['price'])).toList(),
);
} else {
throw Exception('Failed to load invoice');
}
}


// Example: send payment intent
Future<Map<String, dynamic>> createPayment(String invoiceId, String method) async {
final uri = Uri.parse('\$baseUrl/pay');
final res = await http.post(uri, body: {'invoice_id': invoiceId, 'method': method});
if (res.statusCode == 200) {
return jsonDecode(res.body);
}
throw Exception('Payment failed');
}
}