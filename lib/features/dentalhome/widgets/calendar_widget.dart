import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class CalendarWidget extends StatefulWidget {
  final int selectedDay;
  final Function(int day, int month, int year) onDaySelected;

  const CalendarWidget({
    Key? key,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  int currentMonth = 11; // November
  int currentYear = 2025;

  List<String> months = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  /// Hitung jumlah hari dalam bulan & tahun tertentu
  int _daysInMonth(int month, int year) {
    return DateUtils.getDaysInMonth(year, month);
  }

  void _nextMonth() {
    setState(() {
      if (currentMonth == 12) {
        currentMonth = 1;
        currentYear++;
      } else {
        currentMonth++;
      }
    });
  }

  void _previousMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalDays = _daysInMonth(currentMonth, currentYear);

    return Column(
      children: [
        // MONTH HEADER with arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            ),

            Text(
              "${months[currentMonth - 1]} $currentYear",
              style: AppTextStyles.heading,
            ),

            IconButton(
              onPressed: _nextMonth,
              icon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Weekday labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _WeekdayLabel("Su"),
            _WeekdayLabel("Mo"),
            _WeekdayLabel("Tu"),
            _WeekdayLabel("We"),
            _WeekdayLabel("Th"),
            _WeekdayLabel("Fr"),
            _WeekdayLabel("Sa"),
          ],
        ),

        const SizedBox(height: 10),

        // Day grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: totalDays,
          itemBuilder: (context, index) {
            final day = index + 1;
            final isSelected =
                (day == widget.selectedDay); // or adjust based on month change?

            return GestureDetector(
              onTap: () {
                widget.onDaySelected(day, currentMonth, currentYear);
              },
              child: Center(
                child: isSelected
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gold,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '$day',
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text('$day', style: AppTextStyles.label),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;

  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.label,
        ),
      ),
    );
  }
}
