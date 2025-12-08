import 'package:flutter/material.dart';
import '../../../core/models/nota_model.dart';

class PembayaranBerhasilScreen extends StatelessWidget {
  final InvoiceModel invoice;

  const PembayaranBerhasilScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141218),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 90, color: Colors.amber),
            SizedBox(height: 12),
            Text("Pembayaran Berhasil", style: TextStyle(fontSize: 24, color: Colors.amber, fontWeight: FontWeight.bold)),
            Text("Berikut nota pembayaran anda", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFF1E1B22), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _row("Nama Pasien", invoice.namaPasien),
                  _row("ID Invoice", invoice.invoiceId),
                  _row("Tanggal", invoice.tanggal),
                ],
              ),
            ),

            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFF1E1B22), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rincian Perawatan", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 12),

                  ...invoice.items.map((e) => _row(e.nama, "Rp ${e.harga}")),

                  Divider(color: Colors.white24),
                  _row("Subtotal", "Rp ${invoice.subtotal}"),
                  _row("Uang Booking", "-Rp ${invoice.booking}"),

                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("+ 800 poin", style: TextStyle(color: Colors.amber)),
                      Text("Rp ${invoice.totalAkhir}", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String l, String r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(color: Colors.white70)),
        Text(r, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
