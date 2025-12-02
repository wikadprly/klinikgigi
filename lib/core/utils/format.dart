import 'package:intl/intl.dart';


String formatCurrency(int value) {
final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
return f.format(value);
}


String formatDate(DateTime dt) {
final f = DateFormat('d MMMM yyyy', 'id_ID');
return f.format(dt);
}