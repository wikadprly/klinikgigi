import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_card.dart';
import '../widgets/bottom_schedule_card.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import '../providers/home_care_provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // State Tanggal (UI State is fine here as it drives the query)
  DateTime _selectedDate = DateTime.now();

  // Selected Index (UI State)
  int _selectedIndex = -1;

  // Selected Filter (UI State)
  String _selectedFilter = 'Semua';

  // State Keluhan (UI Input)
  String? _selectedComplaint;
  final TextEditingController _otherComplaintController =
      TextEditingController();
  final List<String> _complaintTypes = [
    'Sakit Gigi',
    'Pencabutan Gigi',
    'Scaling / Pembersihan',
    'Tambal Gigi',
    'Konsultasi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDoctors();
    });
  }

  void _fetchDoctors() {
    final provider = Provider.of<HomeCareProvider>(context, listen: false);
    provider.fetchDoctors(_selectedDate, filterCategory: _selectedFilter);
    setState(() => _selectedIndex = -1); // Reset selection
  }

  // Handle konfirmasi tombol bawah
  void _onConfirmBooking() {
    final provider = Provider.of<HomeCareProvider>(context, listen: false);
    final displayedDoctors = provider.availableDoctors;

    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih dokter terlebih dahulu")),
      );
      return;
    }

    if (_selectedComplaint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih jenis keluhan")),
      );
      return;
    }

    if (_selectedComplaint == 'Lainnya' &&
        _otherComplaintController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan isi detail keluhan lainnya")),
      );
      return;
    }

    // Ambil data
    final selectedDoc = displayedDoctors[_selectedIndex];
    final masterJadwal = selectedDoc['master_jadwal'];
    final dokter = masterJadwal['dokter'];

    // Data aman
    final int jadwalId = masterJadwal['id'];
    final String tgl = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final String namaDokter = dokter?['nama'] ?? 'Dokter';
    final String jam =
        "${masterJadwal['jam_mulai']} - ${masterJadwal['jam_selesai']}";

    // Ambil spesialis aman
    String spesialis = '-';
    if (dokter != null && dokter['spesialis'] != null) {
      spesialis = dokter['spesialis']['nama'] ?? '-';
    } else if (dokter != null) {
      spesialis = dokter['spesialisasi'] ?? '-';
    }

    Navigator.pushNamed(
      context,
      '/dentalhome/input_lokasi',
      arguments: {
        'masterJadwalId': jadwalId,
        'tanggal': tgl,
        'namaDokter': namaDokter,
        'jamPraktek': jam,
        'spesialis': spesialis,
        'jenisKeluhan': _selectedComplaint,
        'jenisKeluhanLainnya': _selectedComplaint == 'Lainnya'
            ? _otherComplaintController.text.trim()
            : null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
          // Cleaned up navigation pop
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Pilih Jadwal Kunjungan",
          style: AppTextStyles.heading,
        ),
      ),
      body: Consumer<HomeCareProvider>(
        builder: (context, provider, child) {
          final displayedDoctors = provider.availableDoctors;
          final isLoading = provider.isLoadingDoctors;
          final filterCategories = provider.filterCategories;

          return Stack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ==== 1. CALENDAR WIDGET ====
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: CalendarWidget(
                              selectedDay: _selectedDate.day,
                              onDaySelected: (day, month, year) {
                                setState(() {
                                  _selectedDate = DateTime(year, month, day);
                                  _selectedFilter =
                                      'Semua'; // Reset filter date change
                                });
                                _fetchDoctors();
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ==== 2. PILIH JENIS KELUHAN ====
                          _buildComplaintInput(),

                          const SizedBox(height: 20),

                          // ==== 3. HEADER LIST ====
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.medical_services,
                                      color: AppColors.gold,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Dokter Tersedia",
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${displayedDoctors.length} Dokter",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ==== 4. FILTER CHIPS ====
                          if (displayedDoctors.isNotEmpty ||
                              _selectedFilter != 'Semua')
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Row(
                                children: filterCategories.map((category) {
                                  final isSelected =
                                      _selectedFilter == category;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(category),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            _selectedFilter = category;
                                            _selectedIndex = -1;
                                          });
                                          _fetchDoctors();
                                        }
                                      },
                                      backgroundColor: AppColors.cardDark,
                                      selectedColor: AppColors.gold,
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppColors.gold
                                              : Colors.white24,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          if (displayedDoctors.isNotEmpty ||
                              _selectedFilter != 'Semua')
                            const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // ==== 5. LIST DOKTER (SLIVERS) ====
                    if (isLoading)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        ),
                      )
                    else if (displayedDoctors.isEmpty ||
                        provider.errorMessage != null)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                provider.errorMessage != null
                                    ? Icons.error_outline
                                    : Icons.event_busy,
                                color: Colors.grey,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                provider.errorMessage != null
                                    ? "Gagal memuat: ${provider.errorMessage}"
                                    : "Tidak ada dokter tersedia\npada tanggal ini.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (provider.errorMessage != null) ...[
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _fetchDoctors,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gold,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text("Coba Lagi"),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            final item = displayedDoctors[i];
                            final jadwal = item['master_jadwal'];
                            final dokter = jadwal?['dokter'];

                            final int kuotaSisa = item['kuota_sisa'] ?? 0;
                            final int kuotaMaster = item['kuota_master'] ?? 0;

                            final String namaDokter =
                                dokter?['nama'] ?? 'Dokter Tanpa Nama';
                            final String spesialis =
                                dokter?['spesialis']?['nama'] ??
                                dokter?['spesialis']?['nama_poli'] ??
                                dokter?['spesialisasi'] ??
                                '-';
                            final String jamPraktek =
                                "${jadwal?['jam_mulai'] ?? '00:00'} - ${jadwal?['jam_selesai'] ?? '00:00'}";

                            final Map<String, String> doctorDataMap = {
                              'name': namaDokter,
                              'time': jamPraktek,
                              'quota': "$kuotaSisa/$kuotaMaster",
                              'spesialis': spesialis,
                            };

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DoctorCard(
                                doctor: doctorDataMap,
                                selected: i == _selectedIndex,
                                onSelect: () {
                                  if (kuotaSisa > 0) {
                                    setState(() => _selectedIndex = i);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Kuota dokter ini sudah penuh",
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }, childCount: displayedDoctors.length),
                        ),
                      ),
                  ],
                ),
              ),

              // ==== 6. BOTTOM CARD ====
              if (_selectedIndex != -1 &&
                  _selectedIndex < displayedDoctors.length)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomScheduleCard(
                    doctorName:
                        displayedDoctors[_selectedIndex]['master_jadwal']['dokter']['nama'] ??
                        'Dokter',
                    onConfirm: _onConfirmBooking,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildComplaintInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jenis Keluhan",
            style: TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedComplaint,
                hint: Text(
                  "Pilih Keluhan",
                  style: AppTextStyles.input.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.gold,
                  size: 28,
                ),
                dropdownColor: AppColors.cardWarmDark,
                style: AppTextStyles.input,
                items: _complaintTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedComplaint = newValue;
                  });
                },
              ),
            ),
          ),
          if (_selectedComplaint == 'Lainnya') ...[
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: _otherComplaintController,
                style: AppTextStyles.input,
                decoration: const InputDecoration(
                  hintText: "Tuliskan keluhan Anda...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
