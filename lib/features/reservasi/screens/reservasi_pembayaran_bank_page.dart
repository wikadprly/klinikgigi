import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
<<<<<<< HEAD
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back_button_circle.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/persegi_panjang_garis.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/transfer_bank_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/qris_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/pay_button.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReservasiPembayaranBankPage(),
    ),
  );
}

class ReservasiPembayaranBankPage extends StatefulWidget {
  const ReservasiPembayaranBankPage({Key? key}) : super(key: key);
=======
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/qris_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/transfer_bank_option.dart';

class ReservasiPembayaranBankPage extends StatefulWidget {
  const ReservasiPembayaranBankPage({super.key});
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  @override
  State<ReservasiPembayaranBankPage> createState() =>
      _ReservasiPembayaranBankPageState();
}

class _ReservasiPembayaranBankPageState
    extends State<ReservasiPembayaranBankPage> {
<<<<<<< HEAD
  String? selectedMethod;
=======
  String _selectedPaymentMethod = 'Transfer Bank';
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButtonCircle(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Kode Pembayaran",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 35),

              // ===== DETAIL PEMBAYARAN =====
              Text(
                "Detail Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 15),

              PersegiPanjang(
                width: double.infinity,
                height: 185,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _DetailRow(
                      title: "Nama Lengkap",
                      value: "Farel Sheva Basudewa",
                    ),
                    _DetailRow(title: "Poli", value: "Gigi Anak"),
                    _DetailRow(title: "Dokter", value: "drg. Salma Putri"),
                    _DetailRow(
                      title: "Hari / Tanggal",
                      value: "Kamis, 14 Nov 2025",
                    ),
                    _DetailRow(
                      title: "Waktu Layanan",
                      value: "09.00 - 10.00 WIB",
                    ),
                    _DetailRow(title: "Keluhan", value: "Gigi berlubang"),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ===== RINCIAN PEMBAYARAN =====
              Text(
                "Rincian Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 15),

              PersegiPanjangGaris(
                width: double.infinity,
                height: 100,
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
                    const SizedBox(height: 15),
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
                      "Rp25.000",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Rp25.000",
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.bold,
                      ),
=======
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonCircle(),
                  const SizedBox(width: 24),
                  Text(
                    "Kode Pembayaran",
                    style: AppTextStyles.heading.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.goldDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Detail pendaftaran",
                style: AppTextStyles.heading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.goldDark.withOpacity(0.5),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Nama Lengkap"),
                    _buildDetailItem("Poli"),
                    _buildDetailItem("Dokter"),
                    _buildDetailItem("Hari / Tanggal"),
                    _buildDetailItem("Waktu Layanan"),
                    _buildDetailItem("Keluhan"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Rincian Pembayaran",
                style: AppTextStyles.heading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.goldDark.withOpacity(0.5),
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    _buildPaymentRow("Biaya Awal", "Rp25.000", isTotal: false),
                    Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: AppColors.inputBorder,
                    ),
                    _buildPaymentRow(
                      "Total Pembayaran",
                      "Rp 25.000",
                      isTotal: true,
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD

              const SizedBox(height: 40),

              // ===== METODE PEMBAYARAN =====
              Text(
                "Metode Pembayaran",
                style: AppTextStyles.heading.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMethod == "bank"
                        ? AppColors.goldDark
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TransferBankOption(
                  isSelected: selectedMethod == "bank",
                  onTap: () => setState(() => selectedMethod = "bank"),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMethod == "qris"
                        ? AppColors.goldDark
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrisOption(
                  isSelected: selectedMethod == "qris",
                  onTap: () => setState(() => selectedMethod = "qris"),
                ),
              ),

              const SizedBox(height: 45),

              PayButton(
                onPressed: () {
                  if (selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Pilih metode pembayaran terlebih dahulu",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Metode '$selectedMethod' dipilih"),
                      ),
                    );
                  }
                },
                isEnabled: selectedMethod != null,
              ),

              const SizedBox(height: 25),
=======
              const SizedBox(height: 30),
              Text(
                "Metode Pembayaran",
                style: AppTextStyles.heading.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              TransferBankOption(
                isSelected: _selectedPaymentMethod == 'Transfer Bank',
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'Transfer Bank';
                  });
                },
              ),
              const SizedBox(height: 12),
              QrisOption(
                isSelected: _selectedPaymentMethod == 'QRIS',
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'QRIS';
                  });
                },
              ),
              const SizedBox(height: 40),
              AuthButton(
                text: ButtonText.bayar,
                onPressed: () async {
                  debugPrint('Membayar menggunakan $_selectedPaymentMethod');
                },
              ),
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}

// ===== WIDGET DETAIL ROW =====
class _DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const _DetailRow({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
=======

  Widget _buildDetailItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {required bool isTotal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: isTotal ? AppColors.textLight : AppColors.textMuted,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.input.copyWith(
            color: isTotal ? AppColors.gold : AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
>>>>>>> 24fd746f58f9d4ffab54d5b1829ae178b7c74cca
}
