import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_card.dart';
import '../widgets/bottom_schedule_card.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/core/services/home_care_service.dart';

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
      // TODO: Ambil token asli dari SharedPreferences/Storage aplikasi Anda
      String token = "TOKEN_SEMENTARA_ATAU_AMBIL_DARI_STORAGE";

      // Format tanggal ke YYYY-MM-DD untuk API Laravel
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

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

  // Handle konfirmasi tombol bawah
  void _onConfirmBooking() {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih dokter terlebih dahulu")),
      );
      return;
    }

    // Ambil data dengan aman (Null Safety)
    final selectedDoc = _availableDoctors[_selectedIndex];
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
      },
    );
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

                // ==== 1. HEADER ====
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

                // ==== 2. CALENDAR WIDGET ====
                CalendarWidget(
                  selectedDay: _selectedDate.day,
                  // Asumsi widget Anda menerima callback (day, month, year)
                  onDaySelected: (day, month, year) {
                    setState(() {
                      _selectedDate = DateTime(year, month, day);
                    });
                    // Panggil API ulang setiap ganti tanggal
                    _fetchDoctors();
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

                // ==== 3. LIST DOKTER DINAMIS ====
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _availableDoctors.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada dokter tersedia\npada tanggal ini.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 150),
                          itemCount: _availableDoctors.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            // 1. AMBIL DATA DARI LIST
                            final item = _availableDoctors[i];
                            final jadwal = item['master_jadwal'];
                            final dokter =
                                jadwal?['dokter']; // Pakai ? jaga-jaga kalau jadwal null

                            // 2. DEFINISIKAN KUOTA (PENTING: Ini yang bikin error sebelumnya hilang)
                            // Mengambil angka kuota dari JSON backend
                            final int kuotaSisa = item['kuota_sisa'] ?? 0;
                            final int kuotaMaster = item['kuota_master'] ?? 0;

                            // 3. MAPPING DATA (NULL SAFETY)
                            // Menggunakan '??' untuk memberi nilai default strip '-' jika data null
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
                              'quota':
                                  "$kuotaSisa/$kuotaMaster", // Menampilkan sisa/total
                              'spesialis': spesialis,
                            };

                            // 4. RETURN WIDGET
                            return DoctorCard(
                              doctor: doctorDataMap,
                              selected: i == _selectedIndex,
                              onSelect: () {
                                // LOGIKA PENGECEKAN KUOTA
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
                    _availableDoctors[_selectedIndex]['master_jadwal']['dokter']['nama'],
                onConfirm: _onConfirmBooking,
              ),
            ),
        ],
      ),
    );
  }
}
