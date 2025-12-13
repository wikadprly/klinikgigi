import 'package:flutter/material.dart';

class PembayaranBookingBCA extends StatefulWidget {
  const PembayaranBookingBCA({super.key});

  @override
  State<PembayaranBookingBCA> createState() => _PembayaranBookingBCAState();
}

class _PembayaranBookingBCAState extends State<PembayaranBookingBCA> {
  int hours = 23;
  int minutes = 58;
  int seconds = 31;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          seconds--;
          if (seconds < 0) {
            seconds = 59;
            minutes--;

            if (minutes < 0) {
              minutes = 59;
              hours--;
            }
          }

          if (hours >= 0 && minutes >= 0 && seconds >= 0) {
            startTimer();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentDetailsSection(),
              const SizedBox(height: 24),
              const Divider(thickness: 1),
              const SizedBox(height: 24),
              _buildBcaSection(),
              const SizedBox(height: 32),
              _buildMBankingInstructions(),
              const SizedBox(height: 32),
              _buildAtmInstructions(),
              const SizedBox(height: 32),
              _buildCopyButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildPaymentDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Pembayaran',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Rp25.000',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700]),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bayar Dalam',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Text(
                '$hours jam $minutes menit $seconds detik',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBcaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/bca_logo.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'BCA',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Bank BCA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Text(
          'No. Rek/Virtual Account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '123 4567 8910 1112',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.grey[800]),
              ),
              IconButton(
                onPressed: () => _showCopySuccess(context),
                icon: const Icon(Icons.copy, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMBankingInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Petunjuk Transfer mBanking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInstructionStep(
            number: 1,
            text: 'Pilih m-Transfer > BCA Virtual Account.'),
        const SizedBox(height: 12),
        _buildInstructionStep(
            number: 2,
            text: 'Masukkan nomor Virtual Account 123 4567 8910 1112 dan pilih Send.'),
        const SizedBox(height: 12),
        _buildInstructionStep(
            number: 3, text: 'Masukkan PIN m-BCA Anda dan pilih OK.'),
      ],
    );
  }

  Widget _buildAtmInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Petunjuk Transfer ATM',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInstructionStep(
            number: 1,
            text:
                'Pilih Transaksi Lainnya > Transfer > Ke Rek BCA Virtual Account.'),
        const SizedBox(height: 12),
        _buildInstructionStep(
            number: 2,
            text:
                'Masukkan nomor Virtual Account 123 4567 8910 1112 dan pilih Benar.'),
      ],
    );
  }

  Widget _buildInstructionStep(
      {required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(14)),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 16, height: 1.4)),
        ),
      ],
    );
  }

  Widget _buildCopyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showCopySuccess(context),
        icon: const Icon(Icons.copy, size: 20),
        label: const Text('Salin Nomor Virtual Account'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue[50],
          foregroundColor: Colors.blue[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showPaymentConfirmation(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Saya Sudah Bayar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _showCopySuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nomor Virtual Account berhasil disalin!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content:
            const Text('Apakah Anda sudah melakukan pembayaran?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Belum'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Terima kasih! Pembayaran Anda sedang diverifikasi.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Sudah'),
          ),
        ],
      ),
    );
  }
}
