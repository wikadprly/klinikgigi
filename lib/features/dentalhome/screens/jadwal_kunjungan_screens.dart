// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pilih Jadwal Kunjungan',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1724),
        primaryColor: const Color(0xFFF2D478),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SchedulePage(),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int selectedDay = 3; // default highlighted
  int selectedDoctorIndex = 0;

  final List<int> days = List<int>.generate(30, (i) => i + 1);

  final List<Map<String, String>> doctors = [
    {
      'name': 'Drg. Bawa Adiwinarnom, M.Med.Ed., Sp.Ort',
      'time': 'Senin | 17:30–22:00',
      'quota': '0/2'
    },
    {
      'name': 'Drg. Raden Ardiansyah, M.Med.Ed., Sp.Ort',
      'time': 'Senin | 17:00–19:00',
      'quota': '0/2'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFFF2D478);
    final bgCard = const Color(0xFF2C2C3E);
    final bottomBg = const Color(0xFF3C3C52);

    return Scaffold(
      body: Stack(
        children: [
          // background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A2E), Colors.black],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Pilih Jadwal Kunjungan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Calendar picker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // month selector
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_left, color: Colors.white),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'November 2025',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // weekday labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _WeekdayLabel('S'),
                          _WeekdayLabel('M'),
                          _WeekdayLabel('T'),
                          _WeekdayLabel('W'),
                          _WeekdayLabel('T'),
                          _WeekdayLabel('F'),
                          _WeekdayLabel('S'),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // days grid (7 columns)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final day = days[index];
                          final isSelected = day == selectedDay;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = day;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: isSelected
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: primary, width: 2),
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '$day',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Section title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Dokter Tersedia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Doctor cards list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: doctors.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final doc = doctors[idx];
                        final selected = idx == selectedDoctorIndex;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgCard,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Spesialisasi', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                                    const SizedBox(height: 6),
                                    Text(doc['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.schedule, size: 18, color: Colors.white70),
                                        const SizedBox(width: 6),
                                        Text(doc['time']!, style: TextStyle(color: Colors.white.withOpacity(0.7))),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.group, size: 18, color: Colors.white70),
                                        const SizedBox(width: 6),
                                        Text('Kuota : ${doc['quota']}', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // pilih button
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDoctorIndex = idx;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: const Color(0xFF1A1A2E),
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                ),
                                child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // bottom confirmation panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bottomBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, -4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jadwal Anda:', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 6),
                        Text(doctors[selectedDoctorIndex]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // place confirmation action here
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF2C2C3E),
                          title: const Text('Konfirmasi'),
                          content: Text('Konfirmasi jadwal pada ${doctors[selectedDoctorIndex]['name']} pada tanggal $selectedDay.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: const Color(0xFF1A1A2E),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text('Konfirmasi Jadwal', style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}
