import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  String metode = "tunai";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),

      // ================================
      //          APP BAR FIX
      // ================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Rincian Tagihan Anda",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================================
            //    INFORMASI PASIEN & INVOICE
            // ================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRow("Nama Pasien", "Farel0000"),
                  const SizedBox(height: 8),
                  _buildRow("ID Invoice", "#INV–3K–231024–001"),
                  const SizedBox(height: 8),
                  _buildRow("Tanggal", "3 November 2025"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================
            //    RINCIAN PERAWATAN
            // ================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rincian Perawatan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildRow("Scaling Gigi", "Rp 500.000"),
                  const SizedBox(height: 6),
                  _buildRow("Tambal Komposit", "Rp 750.000"),

                  const SizedBox(height: 12),
                  Container(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 12),

                  _buildRow("Subtotal", "Rp 1.250.000"),
                  const SizedBox(height: 6),
                  _buildRow("Uang Booking", "-Rp 25.000"),

                  const SizedBox(height: 12),
                  Container(
                    height: 1,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(height: 12),

                  _buildRowBold("Total Akhir", "Rp 1.225.000",
                      color: Colors.yellow),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            //     PILIH METODE PEMBAYARAN
            // ================================
            const Text(
              "Pilih Metode Pelunasan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetodePembayaran(
                  icon: Icons.money,
                  label: "Tunai",
                  selected: metode == "tunai",
                  onTap: () => setState(() => metode = "tunai"),
                ),
                _buildMetodePembayaran(
                  icon: Icons.account_balance,
                  label: "Transfer",
                  selected: metode == "transfer",
                  onTap: () => setState(() => metode = "transfer"),
                ),
                _buildMetodePembayaran(
                  icon: Icons.qr_code_scanner,
                  label: "E-wallet",
                  selected: metode == "ewallet",
                  onTap: () => setState(() => metode = "ewallet"),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ================================
            //     TOMBOL SELESAIKAN PEMBAYARAN
            // ================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Arahkan ke halaman "Pembayaran Berhasil"
                  // Navigator.push(context, MaterialPageRoute(builder: (c) => PembayaranBerhasilPage()));
                },
                child: const Text(
                  "Selesaikan Pembayaran",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Unduh Invoice",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET UNTUK KOTAK PEMBAYARAN
  Widget _buildMetodePembayaran({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.yellow : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.yellow : Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.yellow : Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  //   SMALL WIDGET HELPER
  // ================================

  Widget _buildRow(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: const TextStyle(color: Colors.grey)),
        Text(
          right,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRowBold(String left, String right, {Color color = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          right,
          style: TextStyle(
              color: color, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
