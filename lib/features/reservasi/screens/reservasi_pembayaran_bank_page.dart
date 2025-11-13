import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
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

  @override
  State<ReservasiPembayaranBankPage> createState() =>
      _ReservasiPembayaranBankPageState();
}

class _ReservasiPembayaranBankPageState
    extends State<ReservasiPembayaranBankPage> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  const SizedBox(width: 48), // biar seimbang sama back button
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
                    ),
                  ],
                ),
              ),

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

              // Transfer Bank Option (emas cetar kalau dipilih)
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

              // QRIS Option (emas cetar kalau dipilih)
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
            ],
          ),
        ),
      ),
    );
  }
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
}
