import 'package:flutter/material.dart';

class MidtransPelunasanScreen extends StatefulWidget {
  const MidtransPelunasanScreen({super.key});

  @override
  State<MidtransPelunasanScreen> createState() =>
      _MidtransPelunasanScreenState();
}

class _MidtransPelunasanScreenState extends State<MidtransPelunasanScreen> {
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B20),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.amber),
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= RINCIAN PERAWATAN =================
            const Text(
              "Rincian Perawatan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _card(
              Column(
                children: const [
                  _RowItem("Scaling Gigi", "Rp 500.000"),
                  SizedBox(height: 8),
                  _RowItem("Tambal Komposit", "Rp 750.000"),
                  Divider(color: Colors.amber),
                  _RowItem(
                    "Subtotal",
                    "Rp 1.250.000",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TOTAL PEMBAYARAN =================
            _card(
              Column(
                children: const [
                  _RowItem("Booking", "Rp 25.000"),
                  _RowItem("Biaya estimasi", "Rp 25.000"),
                  Divider(color: Colors.amber),
                  _RowItem(
                    "Total Pembayaran",
                    "Rp 1.225.000",
                    isBold: true,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= METODE PEMBAYARAN =================
            const Text(
              "Metode Pembayaran",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            _paymentMethodTile(
              icon: Icons.account_balance,
              title: "Transfer Bank",
              value: 0,
            ),
            const SizedBox(height: 10),
            _paymentMethodTile(
              icon: Icons.qr_code,
              title: "QRIS / E-Wallet",
              value: 1,
            ),

            const Spacer(),

            /// ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Integrasi Midtrans
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Selesaikan Pembayaran",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= UNDUH INVOICE =================
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Download invoice
                },
                child: const Text(
                  "Unduh Invoice",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= WIDGET =================

  Widget _paymentMethodTile({
    required IconData icon,
    required String title,
    required int value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: selectedMethod == value
            ? Colors.amber.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.amber),
      ),
      child: RadioListTile<int>(
        value: value,
        groupValue: selectedMethod,
        onChanged: (val) {
          setState(() {
            selectedMethod = val!;
          });
        },
        activeColor: Colors.amber,
        title: Row(
          children: [
            Icon(icon, color: Colors.amber),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// ================= CARD CONTAINER =================
Widget _card(Widget child) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.amber),
    ),
    child: child,
  );
}

/// ================= ROW ITEM =================
class _RowItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final Color? color;

  const _RowItem(
    this.title,
    this.value, {
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
