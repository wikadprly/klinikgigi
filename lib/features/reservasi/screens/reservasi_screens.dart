import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/core/models/user_model.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/custom_date_field.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/custom_dropdown_field.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/jadwal_card.dart';
import 'package:flutter_klinik_gigi/features/reservasi/screens/Konfirmasi_data_daftar.dart';

// Pastikan import model master_dokter_model ada agar bisa dipakai tipenya

class ReservasiScreen extends StatefulWidget {
  const ReservasiScreen({super.key});

  @override
  State<ReservasiScreen> createState() => _ReservasiScreenState();
}

class _ReservasiScreenState extends State<ReservasiScreen> {
  String? selectedKodePoli;
  String? selectedKodeDokter;
  String? selectedTanggal;

  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prov = Provider.of<ReservasiProvider>(context, listen: false);

      // Bersihkan data lama biar fresh
      prov.clearData();

      // Load data Poli saat pertama buka
      await prov.fetchPoli();

      try {
        final savedUser = await SharedPrefsHelper.getUser();
        if (savedUser != null) {
          setState(() => _currentUser = savedUser);
        }
      } catch (_) {}
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final reservasiProv = Provider.of<ReservasiProvider>(context);
    final user = _currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============================================================
              // HEADER
              // =============================================================
              Text(
                user?.namaPengguna ?? 'Nama Pasien',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 20,
                  color: AppColors.gold,
                ),
              ),

              Text(
                "No. Rekam Medis: ${user?.rekamMedisId ?? '-'}",
                style: AppTextStyles.label,
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Pilih Jadwal Periksa",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 20,
                    color: AppColors.gold,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // =============================================================
              // PILIH POLI
              // =============================================================
              Text(
                "Pilih Poli",
                style: AppTextStyles.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),

              CustomDropdownField(
                label: "Pilih Poli",
                items: reservasiProv.poliList.map((p) => p.namaPoli).toList(),
                value: selectedKodePoli == null
                    ? null
                    : reservasiProv.poliList
                          .firstWhere(
                            (p) => p.kodePoli == selectedKodePoli,
                            orElse: () => reservasiProv.poliList.first,
                          )
                          .namaPoli,
                onChanged: (val) async {
                  final poli = reservasiProv.poliList.firstWhere(
                    (p) => p.namaPoli == val,
                  );

                  setState(() {
                    selectedKodePoli = poli.kodePoli;
                    selectedKodeDokter = null;
                    selectedTanggal = null;
                  });

                  // Update Provider
                  reservasiProv.setSelectedPoli(poli);
                  // Ambil data dokter baru sesuai poli
                  await reservasiProv.fetchDokterByPoli(poli.kodePoli);
                },
              ),

              const SizedBox(height: 25),

              // =============================================================
              // PILIH DOKTER (OPSIONAL)
              // =============================================================
              Text(
                "Pilih Dokter",
                style: AppTextStyles.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),

              CustomDropdownField(
                label: "Pilih Dokter (Opsional)",
                items: reservasiProv.dokterList
                    .map((d) => d.namaLengkap)
                    .toList(),
                value:
                    (selectedKodeDokter == null ||
                        reservasiProv.dokterList.isEmpty)
                    ? null
                    : reservasiProv.dokterList
                          .firstWhere(
                            (d) => d.kodeDokter == selectedKodeDokter,
                            orElse: () => reservasiProv.dokterList.first,
                          )
                          .namaLengkap,
                onChanged: (val) {
                  final dokter = reservasiProv.dokterList.firstWhere(
                    (d) => d.namaLengkap == val,
                  );

                  setState(() {
                    selectedKodeDokter = dokter.kodeDokter;
                  });

                  reservasiProv.setSelectedDokter(dokter);
                },
              ),

              const SizedBox(height: 25),

              // =============================================================
              // PILIH TANGGAL (OPSIONAL)
              // =============================================================
              Text(
                "Pilih Tanggal",
                style: AppTextStyles.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),

              CustomDateField(
                label: "Pilih Tanggal (Opsional)",
                displayedDate: selectedTanggal,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedTanggal = formatDate(picked);
                    });
                  }
                },
              ),

              const SizedBox(height: 40),

              // =============================================================
              // BUTTON CEK JADWAL
              // =============================================================
              AuthButton(
                text: "Cek Jadwal",
                // Tombol hanya mati jika Poli belum dipilih
                onPressed: (selectedKodePoli == null)
                    ? null
                    : () async {
                        // Panggil fetchJadwal dengan parameter yang aman
                        await reservasiProv.fetchJadwal(
                          kodePoli: selectedKodePoli!, // Wajib
                          kodeDokter:
                              selectedKodeDokter, // Opsional (bisa null)
                          tanggalReservasi:
                              selectedTanggal, // Opsional (bisa null)
                        );

                        if (context.mounted) {
                          if (reservasiProv.jadwalList.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Jadwal tidak ditemukan."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Jadwal diperbarui"),
                                backgroundColor: AppColors.gold,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
              ),

              const SizedBox(height: 25),

              // =============================================================
              // LIST JADWAL
              // =============================================================
              Consumer<ReservasiProvider>(
                builder: (context, prov, _) {
                  if (prov.isLoadingJadwal) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      ),
                    );
                  }

                  if (prov.jadwalList.isEmpty) {
                    // Jika poli belum dipilih, kosongkan saja tampilannya
                    if (selectedKodePoli == null) return const SizedBox();

                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "Tidak ada jadwal tersedia untuk kriteria ini.",
                          style: AppTextStyles.label,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prov.jadwalList.length,
                    itemBuilder: (context, index) {
                      final jadwal = prov.jadwalList[index];

                      // 🛠️ PENTING: MENCARI NAMA DOKTER
                      String namaDokterTampil = jadwal.kodeDokter;
                      try {
                        final dokterObj = prov.dokterList.firstWhere(
                          (d) => d.kodeDokter == jadwal.kodeDokter,
                        );
                        namaDokterTampil = dokterObj.namaLengkap;
                      } catch (_) {
                        // Fallback jika tidak ketemu
                        namaDokterTampil = "Dokter ${jadwal.kodeDokter}";
                      }

                      // 🔥 LOGIC UI STATUS (Agar tombol tidak bisa diklik jika penuh/libur)
                      bool isAvailable = jadwal.statusJadwal == 'Tersedia';
                      String statusText =
                          jadwal.statusJadwal; // 'Tersedia', 'Penuh', 'Libur'

                      return Opacity(
                        // Bikin agak transparan kalau tidak tersedia biar kelihatan inactive
                        opacity: isAvailable ? 1.0 : 0.6,
                        child: ScheduleCardWidget(
                          namaPoli: prov.selectedPoli?.namaPoli ?? '-',
                          namaDokter: namaDokterTampil,
                          hari: jadwal.hari,
                          jam: "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                          quota: jadwal.quota,
                          kuotaTerpakai: jadwal.kuotaTerpakai,

                          // 🔥 UPDATE DISINI: KIRIM TANGGAL KE WIDGET
                          // Jika user memilih tanggal, tampilkan. Jika tidak, kosong.
                          tanggal: selectedTanggal,

                          onTap: () {
                            // 1. Validasi Tanggal
                            if (selectedTanggal == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Harap pilih tanggal terlebih dahulu untuk melakukan booking.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 2. 🔥 VALIDASI BARU: CEK STATUS JADWAL
                            if (!isAvailable) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Maaf, jadwal ini $statusText.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) {
                                return KonfirmasiReservasiSheet(
                                  namaPasien: user?.namaPengguna ?? "-",
                                  rekamMedis:
                                      user?.rekamMedisId.toString() ?? "-",
                                  poli: prov.selectedPoli?.namaPoli ?? '-',
                                  dokter: namaDokterTampil,
                                  tanggal: selectedTanggal!,
                                  jam:
                                      "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                                  keluhan: "-",
                                  total: 25000,

                                  // Data Backend (Kirim ID Int & String Dokter)
                                  jadwalId: jadwal.id,
                                  dokterId: jadwal.kodeDokter,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
