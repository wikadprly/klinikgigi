import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';
import '../../../core/models/master_jadwal_model.dart';

class DokterJadwalTab extends StatelessWidget {
  final List<MasterJadwalModel>? jadwalList;

  const DokterJadwalTab({super.key, required this.jadwalList});

  String _convertDay(String dayCode) {
    switch (dayCode) {
      case '1':
        return 'Senin';
      case '2':
        return 'Selasa';
      case '3':
        return 'Rabu';
      case '4':
        return 'Kamis';
      case '5':
        return 'Jumat';
      case '6':
        return 'Sabtu';
      case '7':
        return 'Minggu';
      default:
        return dayCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jadwalList == null || jadwalList!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada jadwal tersedia',
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    // Sort days
    Map<String, List<MasterJadwalModel>> jadwalByHari = {};
    for (var jadwal in jadwalList!) {
      String dayName = _convertDay(jadwal.hari);
      if (jadwalByHari.containsKey(dayName)) {
        jadwalByHari[dayName]!.add(jadwal);
      } else {
        jadwalByHari[dayName] = [jadwal];
      }
    }

    final dayOrder = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final sortedKeys = jadwalByHari.keys.toList()
      ..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final hari = sortedKeys[index];
        final jadwals = jadwalByHari[hari]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: AppColors.background,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      hari,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 16,
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ...jadwals
                  .map(
                    (jadwal) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled,
                                color: AppColors.gold,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${jadwal.jamMulai.substring(0, 5)} - ${jadwal.jamSelesai.substring(0, 5)}',
                                style: AppTextStyles.input.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.5),
                              ),
                            ),
                            child: const Text(
                              "Tersedia",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
