import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/Pembayaran_awal.dart';
import 'package:provider/provider.dart';

class KonfirmasiReservasiSheet extends StatefulWidget {
  final String namaPasien;
  final String rekamMedis;
  final String poli;
  final String dokter;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int total;

  const KonfirmasiReservasiSheet({
    super.key,
    required this.namaPasien,
    required this.rekamMedis,
    required this.poli,
    required this.dokter,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.total,
  });

  @override
  State<KonfirmasiReservasiSheet> createState() =>
      _KonfirmasiReservasiSheetState();
}

class _KonfirmasiReservasiSheetState extends State<KonfirmasiReservasiSheet> {
  late TextEditingController keluhanController;

  @override
  void initState() {
    super.initState();
    keluhanController = TextEditingController(text: widget.keluhan);
  }

  @override
  void dispose() {
    keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservasiProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 5,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            Text(
              "Konfirmasi Data Pendaftaran",
              style: AppTextStyles.heading.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            _item("Nama Lengkap", widget.namaPasien),
            _item("No. Rekam Medis", widget.rekamMedis),
            _item("Poli", widget.poli),
            _item("Dokter", widget.dokter),
            _item("Tanggal", widget.tanggal),
            _item("Waktu Layanan", widget.jam),

            const SizedBox(height: 10),

            // ===========================
            // TEXTFIELD KELUHAN (FIXED)
            // ===========================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Keluhan", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: keluhanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Tuliskan keluhan Anda...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    provider.setKeluhan(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            divider(),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: AppTextStyles.label.copyWith(color: Colors.white70),
                ),
                Text(
                  "Rp ${widget.total}",
                  style: AppTextStyles.heading.copyWith(
                    color: AppColors.gold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservasiPembayaranBankPage(
                            namaLengkap: widget.namaPasien,
                            poli: widget.poli,
                            dokter: widget.dokter,
                            tanggal: widget.tanggal,
                            jam: widget.jam,
                            keluhan: provider.keluhan, // selalu terbaru
                            total: widget.total,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Bayar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: AppTextStyles.input.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() =>
      Container(height: 1, width: double.infinity, color: Colors.white24);
}
