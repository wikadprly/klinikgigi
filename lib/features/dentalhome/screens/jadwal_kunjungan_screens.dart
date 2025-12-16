import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_card.dart';
import '../widgets/bottom_schedule_card.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';

import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/core/services/home_care_service.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart'; // Import Helper

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // State Tanggal
  DateTime _selectedDate = DateTime.now();

  // State Data
  List<dynamic> _availableDoctors = [];
  bool _isLoading = false;
  int _selectedIndex = -1; // -1 artinya belum ada yang dipilih

  // State Keluhan
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

  final HomeCareService _homeCareService = HomeCareService();

  @override
  void initState() {
    super.initState();
    _fetchDoctors(); // Ambil data saat halaman pertama dibuka
  }

  // Fungsi ambil data ke Laravel
  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoading = true;
      _availableDoctors = [];
      _selectedIndex = -1; // Reset pilihan saat ganti tanggal
    });

    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      // Format tanggal ke YYYY-MM-DD untuk API Laravel
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // Pastikan service menggunakan token yang benar (biasanya service ambil sendiri,
      // tapi jika method minta token, pass it here.
      // Asumsi: Service handle token via SharedPrefs internally or header is managed)
      final data = await _homeCareService.getJadwalDokter(formattedDate);

      if (mounted) {
        setState(() {
          _availableDoctors = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // State Filter
  String _selectedFilter = 'Semua';

  List<dynamic> get _filteredDoctors {
    if (_selectedFilter == 'Semua') {
      return _availableDoctors;
    }
    return _availableDoctors.where((item) {
      final dokter = item['master_jadwal']?['dokter'];
      final String spesialis =
          dokter?['spesialis']?['nama_spesialis'] ??
          dokter?['spesialisasi'] ??
          '-';
      return spesialis == _selectedFilter;
    }).toList();
  }

  List<String> get _filterCategories {
    final Set<String> categories = {'Semua'};
    for (var item in _availableDoctors) {
      final dokter = item['master_jadwal']?['dokter'];
      final String spesialis =
          dokter?['spesialis']?['nama_spesialis'] ??
          dokter?['spesialisasi'] ??
          '-';
      categories.add(spesialis);
    }
    return categories.toList();
  }

  // Handle konfirmasi tombol bawah
  void _onConfirmBooking() {
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

    // Ambil data dari FILTERED LIST
    final selectedDoc = _filteredDoctors[_selectedIndex]; // CHANGED THIS
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
      spesialis = dokter['spesialis']['nama_spesialis'] ?? '-';
    } else if (dokter != null) {
      spesialis = dokter['spesialisasi'] ?? '-';
    }

    print("Navigasi ke Input Lokasi dengan ID Jadwal: $jadwalId");

    Navigator.pushNamed(
      context,
      '/dentalhome/input_lokasi', // Pastikan string ini SAMA PERSIS dengan di main.dart
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
    // Use filtered list for display
    final displayedDoctors = _filteredDoctors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Pilih Jadwal Kunjungan",
          style: AppTextStyles.heading,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ==== 2. CALENDAR WIDGET ====
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CalendarWidget(
                    selectedDay: _selectedDate.day,
                    // Asumsi widget Anda menerima callback (day, month, year)
                    onDaySelected: (day, month, year) {
                      setState(() {
                        _selectedDate = DateTime(year, month, day);
                        _selectedFilter = 'Semua'; // Reset filter
                      });
                      // Panggil API ulang setiap ganti tanggal
                      _fetchDoctors();
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ==== 2.5 PILIH JENIS KELUHAN ====
                Padding(
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
                          border: Border.all(
                            color: AppColors.inputBorder,
                            width: 1,
                          ),
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
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      // Optional: Add Item Count
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

                // ==== FILTER CHIPS (NEW) ====
                if (_availableDoctors.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: _filterCategories.map((category) {
                        final isSelected = _selectedFilter == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedFilter = category;
                                  _selectedIndex =
                                      -1; // Reset selection on filter change
                                });
                              }
                            },
                            backgroundColor: AppColors.cardDark,
                            selectedColor: AppColors.gold,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              // Modern shape
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

                if (_availableDoctors.isNotEmpty) const SizedBox(height: 12),

                // ==== 3. LIST DOKTER DINAMIS ====
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                          ),
                        )
                      : displayedDoctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.event_busy,
                                color: Colors.grey,
                                size: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _availableDoctors.isEmpty
                                    ? "Tidak ada dokter tersedia\npada tanggal ini."
                                    : "Tidak ada dokter untuk spesialis ini.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 150),
                          itemCount: displayedDoctors.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            // 1. AMBIL DATA DARI FILTERED LIST
                            final item = displayedDoctors[i];
                            final jadwal = item['master_jadwal'];
                            final dokter =
                                jadwal?['dokter']; // Pakai ? jaga-jaga kalau jadwal null

                            // 2. DEFINISIKAN KUOTA
                            final int kuotaSisa = item['kuota_sisa'] ?? 0;
                            final int kuotaMaster = item['kuota_master'] ?? 0;

                            // 3. MAPPING DATA
                            final String namaDokter =
                                dokter?['nama'] ?? 'Dokter Tanpa Nama';
                            final String spesialis =
                                dokter?['spesialis']?['nama_spesialis'] ??
                                dokter?['spesialisasi'] ??
                                '-';
                            final String jamPraktek =
                                "${jadwal?['jam_mulai'] ?? '00:00'} - ${jadwal?['jam_selesai'] ?? '00:00'}";

                            // Format data untuk widget DoctorCard
                            final Map<String, String> doctorDataMap = {
                              'name': namaDokter,
                              'time': jamPraktek,
                              'quota': "$kuotaSisa/$kuotaMaster",
                              'spesialis': spesialis,
                            };

                            // 4. RETURN WIDGET
                            return DoctorCard(
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
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // ==== 4. BOTTOM CARD ====
          if (_selectedIndex != -1) // Hanya muncul jika ada dokter dipilih
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomScheduleCard(
                doctorName:
                    displayedDoctors[_selectedIndex]['master_jadwal']['dokter']['nama'], // Use filtered list
                onConfirm: _onConfirmBooking,
              ),
            ),
        ],
      ),
    );
  }
}
