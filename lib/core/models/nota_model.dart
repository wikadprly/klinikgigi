import 'treatment_item.dart';


class InvoiceModel {
final String patientName;
final String invoiceId;
final DateTime date;
final List<TreatmentItem> items;
final int bookingDiscount;
final int points;


InvoiceModel({
required this.patientName,
required this.invoiceId,
required this.date,
required this.items,
this.bookingDiscount = 0,
this.points = 0,
});


int get subtotal => items.fold(0, (sum, item) => sum + item.price);
int get total => subtotal - bookingDiscount;
}