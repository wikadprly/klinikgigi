import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_card.dart';
import '../widgets/bottom_schedule_card.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/core/services/homecare_service.dart';

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
  final HomeCareService _service = HomeCareService();
  List<Map<String, String>> doctors = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDay = now.day;
    selectedMonth = now.month;
    selectedYear = now.year;

    _loading = true;
    _service.fetchJadwalForDate(now).then((list) {
      setState(() {
        doctors = list;
        selectedDoctor = 0;
        _loading = false;
      });
    }).catchError((err) {
      setState(() {
        doctors = [];
        _loading = false;
      });
    });
  }

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
                          child: BackButtonWidget(
                            onPressed: () => Navigator.of(context).pop(),
                          ),
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

                /// =========================
                ///   CALENDAR WITH BORDER
                /// =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.goldDark, // warna gold sesuai tema
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.10), 
                    ),
                    child: CalendarWidget(
                      selectedDay: selectedDay,
                      onDaySelected: (day, month, year) {
                        setState(() {
                          selectedDay = day;
                          selectedMonth = month;
                          selectedYear = year;
                          _loading = true;
                          doctors = [];
                        });

                        final selDate = DateTime(year, month, day);
                        _service.fetchJadwalForDate(selDate).then((list) {
                          setState(() {
                            doctors = list;
                            selectedDoctor = 0;
                            _loading = false;
                          });
                        }).catchError((err) {
                          setState(() {
                            doctors = [];
                            _loading = false;
                          });
                        });
                      },
                    ),
                  ),
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
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : doctors.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada dokter tersedia pada tanggal terpilih',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.separated(
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
              doctorName: doctors.isNotEmpty ? doctors[selectedDoctor]['name']! : '-',
              onConfirm: () {
                if (doctors.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: Text(
                        "Konfirmasi jadwal pada tanggal $selectedDay?",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih dokter terlebih dahulu')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
