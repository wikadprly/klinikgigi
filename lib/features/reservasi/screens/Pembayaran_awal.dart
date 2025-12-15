import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang_garis.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/transfer_bank_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/qris_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/pay_button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/Pembayaran_bank.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/Pembayaran_qris.dart';

class ReservasiPembayaranPage extends StatefulWidget {
  final String noPemeriksaan;   
  final String namaLengkap;
  final String poli;
  final String dokter;
  final String tanggal;
  final String jam;
  final String keluhan;
  final int total;

  const ReservasiPembayaranPage({
    Key? key,
    // 🔥 Wajib diisi (Didapat dari Response Backend)
    required this.noPemeriksaan, 
    required this.namaLengkap,
    required this.poli,
    required this.dokter,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.total,
  }) : super(key: key);

  @override
  State<ReservasiPembayaranPage> createState() =>
      _ReservasiPembayaranPageState();
}

class _ReservasiPembayaranPageState extends State<ReservasiPembayaranPage> {
  String? selectedMethod; // "bank" / "qris"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  Text(
                    "Metode Pembayaran", 
                    style: AppTextStyles.heading.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldDark,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 35),

              // ===== KODE PEMBAYARAN =====
              // Menampilkan No Pemeriksaan (RSV-...) agar user tau
              Center(
                child: Column(
                  children: [
                    Text(
                      "Kode Booking",
                      style: AppTextStyles.label.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.noPemeriksaan, // 🔥 Tampilkan Kode RSV Disini
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===== DETAIL PENDAFTARAN =====
              Text(
                "Detail Pendaftaran",
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              PersegiPanjang(
                width: double.infinity,
                height: 205,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetailRow(title: "Nama Lengkap", value: widget.namaLengkap),
                    DetailRow(title: "Poli", value: widget.poli),
                    DetailRow(title: "Dokter", value: widget.dokter),
                    DetailRow(title: "Hari / Tanggal", value: widget.tanggal),
                    DetailRow(title: "Waktu Layanan", value: widget.jam),
                    DetailRow(title: "Keluhan", value: widget.keluhan),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ===== RINCIAN PEMBAYARAN =====
              Text(
                "Rincian Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              PersegiPanjangGaris(
                width: double.infinity,
                height: 110,
                showInnerLine: true,
                leftChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biaya Awal",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "Total Pembayaran",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                rightChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Rp${widget.total}",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "Rp${widget.total}",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ===== METODE PEMBAYARAN =====
              Text(
                "Pilih Metode Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 15),

              // === Transfer Bank ===
              _buildPaymentOption(
                isSelected: selectedMethod == "bank",
                onTap: () => setState(() => selectedMethod = "bank"),
                child: TransferBankOption(
                  isSelected: selectedMethod == "bank",
                  onTap: () => setState(() => selectedMethod = "bank"),
                ),
              ),

              const SizedBox(height: 15),

              // === QRIS ===
              _buildPaymentOption(
                isSelected: selectedMethod == "qris",
                onTap: () => setState(() => selectedMethod = "qris"),
                child: QrisOption(
                  isSelected: selectedMethod == "qris",
                  onTap: () => setState(() => selectedMethod = "qris"),
                ),
              ),

              const SizedBox(height: 45),

              // ===== BUTTON BAYAR =====
              PayButton(
                isEnabled: selectedMethod != null,
                onPressed: () {
                  if (selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih metode pembayaran terlebih dahulu"),
                      ),
                    );
                    return;
                  }

                  if (selectedMethod == "bank") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservasiPembayaranBankPage(
                          // 🔥 TERUSKAN DATA PENTING
                          noPemeriksaan: widget.noPemeriksaan, 
                          namaLengkap: widget.namaLengkap,
                          poli: widget.poli,
                          dokter: widget.dokter,
                          tanggal: widget.tanggal,
                          jam: widget.jam,
                          keluhan: widget.keluhan,
                          total: widget.total,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReservasiPembayaranQrisPage(
                          // 🔥 TERUSKAN DATA PENTING
                          noPemeriksaan: widget.noPemeriksaan, 
                          namaLengkap: widget.namaLengkap,
                          poli: widget.poli,
                          dokter: widget.dokter,
                          tanggal: widget.tanggal,
                          jam: widget.jam,
                          keluhan: widget.keluhan,
                          total: widget.total,
                        ),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Wrapper Payment Option ====
  Widget _buildPaymentOption({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.goldDark : Colors.transparent,
            width: 2.2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      ),
    );
  }
}

// ===== DETAIL ROW WIDGET =====
class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.input.copyWith(
              color: AppColors.textLight,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.input.copyWith(
                color: AppColors.textLight,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}