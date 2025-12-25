import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/models/dokter_detail_model.dart';

class DokterTentangTab extends StatelessWidget {
  final DokterDetailModel dokter;

  const DokterTentangTab({super.key, required this.dokter});

  @override
  Widget build(BuildContext context) {
    String biografi =
        "Dokter ${dokter.nama} adalah tenaga medis profesional yang berdedikasi tinggi di bidang ${dokter.spesialisasi ?? 'kesehatan gigi'}.\n\nBeliau berpraktek di ${dokter.masterPoli?.namaPoli ?? 'Poliklinik kami'} dan dikenal ramah serta teliti dalam menangani pasien.";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            biografi,
            style: AppTextStyles.label.copyWith(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textLight.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
