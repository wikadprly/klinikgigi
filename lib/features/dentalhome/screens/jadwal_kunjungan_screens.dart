import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_card.dart';
import '../widgets/bottom_schedule_card.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int selectedDay = 3;
  int selectedMonth = 2;
  int selectedYear = 1;
  int selectedDoctor = 0;

  final List<Map<String, String>> doctors = [
    {
      'name': 'Drg. Bawa Adiwinarnom, M.Med.Ed., Sp.Ort',
      'time': 'Senin | 17:30–22:00',
      'quota': '0/2',
    },
    {
      'name': 'Drg. Raden Ardiansyah, M.Med.Ed., Sp.Ort',
      'time': 'Senin | 17:00–19:00',
      'quota': '0/2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),

                // ==== BACK BUTTON + HEADING ====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: BackButtonWidget(onPressed: () => Navigator.of(context).pop()),
                        ),
                        const Center(
                          child: Text(
                            "Pilih Jadwal Kunjungan",
                            style: AppTextStyles.heading,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Calendar
                CalendarWidget(
                  selectedDay: selectedDay,
                  onDaySelected: (day, month, year) {
                    setState(() {
                      selectedDay = day;
                      selectedMonth = month;
                      selectedYear = year;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Dokter Tersedia",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 150),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      return DoctorCard(
                        doctor: doctors[i],
                        selected: i == selectedDoctor,
                        onSelect: () => setState(() => selectedDoctor = i),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM CARD
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomScheduleCard(
              doctorName: doctors[selectedDoctor]['name']!,
              onConfirm: () {
                // Navigate to input location screen with the selected doctor and schedule data
                Navigator.pushNamed(
                  context,
                  '/dentalhome/input_lokasi',
                  arguments: {
                    'masterJadwalId': 1, // This would be the actual master jadwal ID in real implementation
                    'tanggal': '2025-12-05', // This would be the selected date in real implementation
                    'namaDokter': doctors[selectedDoctor]['name']!,
                    'jamPraktek': doctors[selectedDoctor]['time']!,
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
