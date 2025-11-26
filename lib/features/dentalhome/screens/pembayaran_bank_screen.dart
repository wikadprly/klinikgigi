import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class PembayaranBankScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PembayaranBankScreen({super.key, required this.bookingData});

  @override
  State<PembayaranBankScreen> createState() => _PembayaranBankScreenState();
}

class _PembayaranBankScreenState extends State<PembayaranBankScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.bookingData;
    final String nominal = data['rincianBiaya']['estimasi_total'].toString();
    final String virtualAccount = "1234567890"; // Ini akan diganti dengan nomor VA dari API
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transfer Bank",
          style: AppTextStyles.heading,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sisa Waktu Pembayaran",
                    style: AppTextStyles.label,
                  ),
                  Text(
                    "23 jam 59 menit",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card Informasi Bank
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "BCA Virtual Account",
                        style: AppTextStyles.label,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Fungsi untuk menyalin nomor rekening ke clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Nomor rekening disalin: $virtualAccount")),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            virtualAccount,
                            style: AppTextStyles.input.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.copy,
                            color: AppColors.gold,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${int.parse(nominal).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})$'), (Match m) => '.${m[1]}').replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '.${m[1]}')}",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Bagian Instruksi
            ExpansionTile(
              title: const Text(
                "Petunjuk Transfer mBanking",
                style: AppTextStyles.label,
              ),
              children: [
                _buildInstructionStep("1. Buka aplikasi BCA Mobile", 1),
                _buildInstructionStep("2. Pilih menu 'm-Transfer'", 2),
                _buildInstructionStep("3. Pilih 'BCA Virtual Account'", 3),
                _buildInstructionStep("4. Masukkan nomor Virtual Account di atas", 4),
                _buildInstructionStep("5. Masukkan jumlah pembayaran sesuai nominal", 5),
                _buildInstructionStep("6. Ikuti instruksi selanjutnya", 6),
              ],
            ),
            
            const SizedBox(height: 12),
            
            ExpansionTile(
              title: const Text(
                "Petunjuk Transfer ATM",
                style: AppTextStyles.label,
              ),
              children: [
                _buildInstructionStep("1. Masukkan kartu debit BCA Anda", 1),
                _buildInstructionStep("2. Pilih Bahasa", 2),
                _buildInstructionStep("3. Masukkan PIN ATM Anda", 3),
                _buildInstructionStep("4. Pilih 'Transfer'", 4),
                _buildInstructionStep("5. Pilih 'Ke Rek. BCA Virtual Account'", 5),
                _buildInstructionStep("6. Ikuti instruksi selanjutnya", 6),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Selesai dan Kembali ke Beranda
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Arahkan ke halaman transaksi berhasil setelah pembayaran
                          // Untuk sementara kembali ke beranda
                          Navigator.of(context).pushReplacementNamed('/dashboard');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Selesai",
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/dashboard');
                      },
                      child: Text(
                        "Kembali ke Beranda",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInstructionStep(String instruction, int stepNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$stepNumber.",
            style: AppTextStyles.label.copyWith(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              instruction,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}