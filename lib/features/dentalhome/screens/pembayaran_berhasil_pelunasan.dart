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
        automaticallyImplyLeading: false, // Hide back button
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 90, color: Colors.amber),
              const SizedBox(height: 12),
              const Text(
                "Pembayaran Berhasil",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Berikut nota pembayaran anda",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _row("Nama Pasien", invoice.namaPasien),
                    _row("ID Invoice", invoice.invoiceId),
                    _row("Tanggal", invoice.tanggal),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rincian Perawatan",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),

                    ...invoice.items.map((e) => _row(e.nama, "Rp ${e.harga}")),

                    const Divider(color: Colors.white24),
                    _row("Subtotal", "Rp ${invoice.subtotal}"),
                    _row("Uang Booking", "-Rp ${invoice.booking}"),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "+ ${(invoice.totalAkhir / 10000).floor()} poin",
                          style: const TextStyle(color: Colors.amber),
                        ),
                        Text(
                          "Rp ${invoice.totalAkhir}",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main_screen',
              (route) => false,
            );
          },
          child: const Text(
            "Kembali ke Beranda",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
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
