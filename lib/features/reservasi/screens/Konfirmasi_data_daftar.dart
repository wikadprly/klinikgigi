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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReservasiProvider>().setKeluhan(widget.keluhan);
      }
    });
  }

  @override
  void dispose() {
    keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservasiProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 25),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dragHandle(),

            const SizedBox(height: 5),
            _titleSection(),
            const SizedBox(height: 20),

            _buildCardSection(),

            const SizedBox(height: 18),
            _keluhanField(provider),

            const SizedBox(height: 22),
            _totalBox(),

            const SizedBox(height: 25),
            _actionButtons(provider),
          ],
        ),
      ),
    );
  }

  Widget _dragHandle() {
    return Center(
      child: Container(
        width: 45,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return Text(
      "Konfirmasi Data Pendaftaran",
      style: AppTextStyles.heading.copyWith(
        color: AppColors.gold,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoItem("Nama Lengkap", widget.namaPasien),
          _infoItem("No. Rekam Medis", widget.rekamMedis),
          _infoItem("Poli", widget.poli),
          _infoItem("Dokter", widget.dokter),
          _infoItem("Tanggal", widget.tanggal),
          _infoItem("Waktu Layanan", widget.jam),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.label.copyWith(color: Colors.white70)),
          const SizedBox(height: 3),
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

  Widget _keluhanField(ReservasiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Keluhan",
            style: AppTextStyles.label.copyWith(color: Colors.white70)),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.goldDark, width: 1),
            color: AppColors.cardDark,
          ),
          child: TextField(
            controller: keluhanController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: "Tuliskan keluhan Anda...",
              hintStyle: TextStyle(color: Colors.white38),
            ),
            onChanged: provider.setKeluhan,
          ),
        ),
      ],
    );
  }

  Widget _totalBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.goldDark),
        borderRadius: BorderRadius.circular(14),
        color: AppColors.cardDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total Pembayaran",
              style: AppTextStyles.label.copyWith(
                color: Colors.white70,
                fontSize: 14,
              )),
          Text(
            "Rp ${widget.total}",
            style: AppTextStyles.heading.copyWith(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(ReservasiProvider provider) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Batal",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
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
                      keluhan: keluhanController.text,
                      total: widget.total,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Bayar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }
}
