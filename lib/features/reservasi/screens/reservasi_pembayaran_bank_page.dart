import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/back.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/qris_option.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/transfer_bank_option.dart';

class ReservasiPembayaranBankPage extends StatefulWidget {
  const ReservasiPembayaranBankPage({super.key});

  @override
  State<ReservasiPembayaranBankPage> createState() =>
      _ReservasiPembayaranBankPageState();
}

class _ReservasiPembayaranBankPageState
    extends State<ReservasiPembayaranBankPage> {
  String _selectedPaymentMethod = 'Transfer Bank';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      color: AppColors.goldDark.withOpacity(0.5), width: 2.0),
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
                      color: AppColors.goldDark.withOpacity(0.5), width: 2.0),
                ),
                child: Column(
                  children: [
                    _buildPaymentRow("Biaya Awal", "Rp25.000", isTotal: false),
                    Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: AppColors.borderSubtle,
                    ),
                    _buildPaymentRow("Total Pembayaran", "Rp 25.000",
                        isTotal: true),
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: AppTextStyles.label
            .copyWith(color: AppColors.textMuted, fontSize: 14),
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
}
