import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class CalendarWidget extends StatefulWidget {
  final int selectedDay;
  final Function(int day, int month, int year) onDaySelected;

  const CalendarWidget({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  // State internal untuk navigasi bulan (default ke bulan sekarang)
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Opsional: Jika ingin mulai langsung di bulan tertentu, set di sini
    // _currentMonth = DateTime(2025, 11, 1);
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
        1,
      );
    });

    // Reset tanggal terpilih ke 0 atau 1 saat ganti bulan (opsional)
    // widget.onDaySelected(1, _currentMonth.month, _currentMonth.year);
  }

  @override
  Widget build(BuildContext context) {
    // Format Bulan & Tahun (Contoh: "November 2025")
    final String monthYear = DateFormat('MMMM yyyy').format(_currentMonth);

    // Hitung jumlah hari dalam bulan ini
    final int daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    // Hitung hari pertama bulan ini jatuh pada hari apa (1=Senin, 7=Minggu)
    final int firstWeekday = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;

    // Hitung offset (Kompensasi karena UI kita mulai dari Minggu/Su)
    // Jika 1st day = Minggu (7), offset 0.
    // Jika 1st day = Senin (1), offset 1.
    final int emptySlots = firstWeekday % 7;

    return Column(
      children: [
        // --- HEADER BULAN & NAVIGASI ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                monthYear,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
        ),

        // --- NAMA HARI (Su Mo Tu...) ---
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // --- GRID TANGGAL ---
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + emptySlots, // Total kotak = kosong + tgl
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, // 7 hari seminggu
            mainAxisSpacing: 8,
            crossAxisSpacing: 0,
          ),
          itemBuilder: (context, index) {
            // Jika index masih dalam range offset, render kotak kosong
            if (index < emptySlots) {
              return Container();
            }

            final int day = index - emptySlots + 1;

            // Check Past Dates
            final DateTime dateToCheck = DateTime(
              _currentMonth.year,
              _currentMonth.month,
              day,
            );
            final DateTime now = DateTime.now();
            final DateTime today = DateTime(now.year, now.month, now.day);
            final bool isPast = dateToCheck.isBefore(today);

            // Cek apakah ini tanggal yang dipilih
            final bool isSelected = (day == widget.selectedDay);

            return GestureDetector(
              onTap: isPast
                  ? null
                  : () {
                      // Disable click if past
                      // Panggil callback ke parent
                      widget.onDaySelected(
                        day,
                        _currentMonth.month,
                        _currentMonth.year,
                      );
                    },
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.transparent : null,
                    border: isSelected
                        ? Border.all(color: AppColors.gold, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: TextStyle(
                        color: isPast
                            ? Colors.grey.withOpacity(0.3)
                            : (isSelected ? AppColors.gold : Colors.white),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
