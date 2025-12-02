import '../models/nota_model.dart';
import 'rincian_service.dart';


class PaymentService {
final ApiService api;
PaymentService({required this.api});


Future<bool> pay(InvoiceModel invoice, String method) async {
// call real API then return result
final result = await api.createPayment(invoice.invoiceId, method);
// Assume API returns { success: true }
return result['success'] == true;
}
}