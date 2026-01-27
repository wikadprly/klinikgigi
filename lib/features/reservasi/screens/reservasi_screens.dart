import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
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

class ReservasiScreen extends StatefulWidget {
  const ReservasiScreen({super.key});

  @override
  State<ReservasiScreen> createState() => _ReservasiScreenState();
}

class _ReservasiScreenState extends State<ReservasiScreen> {
  String? selectedKodePoli;
  String? selectedKodeDokter;
  String? selectedTanggal;

  List<String> availableDates = [];
  List<String> availableDoctors = [];

  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prov = Provider.of<ReservasiProvider>(context, listen: false);
      prov.clearData();
      await prov.fetchPoli();

      try {
        final savedUser = await SharedPrefsHelper.getUser();
        if (savedUser != null) {
          setState(() => _currentUser = savedUser);
        }
      } catch (_) {}
    });
  }

  String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatDateForDisplay(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
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
              // HEADER
              Text(
                user?.namaPengguna ?? 'Nama Pasien',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24,
                  color: AppColors.gold,
                ),
              ),
              Text(
                "No. Rekam Medis: ${user?.rekamMedisId ?? '-'}",
                style: AppTextStyles.label.copyWith(fontSize: 14),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Pilih Jadwal Periksa",
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 18,
                    color: AppColors.gold,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // DROPDOWN POLI
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
                  });

                  reservasiProv.setSelectedPoli(poli);
                  await reservasiProv.fetchDokterByPoli(poli.kodePoli);

                  // Fetch tanggal dengan jadwal berdasarkan poli yang dipilih
                  final rawDates = await reservasiProv.fetchTanggalDenganJadwal(
                    kodePoli: poli.kodePoli,
                    kodeDokter: selectedKodeDokter,
                  );
                  availableDates = rawDates
                      .map((e) => e['tanggal'] as String)
                      .toList();

                  if (selectedTanggal != null &&
                      !availableDates.contains(selectedTanggal)) {
                    setState(() {
                      selectedTanggal = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              // DROPDOWN DOKTER
              CustomDropdownField(
                label: "Pilih Dokter",
                items: availableDoctors.isNotEmpty
                    ? reservasiProv.dokterList
                          .where((d) => availableDoctors.contains(d.kodeDokter))
                          .map((d) => d.namaLengkap)
                          .toList()
                    : reservasiProv.dokterList
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
                onChanged: (val) async {
                  final dokter = reservasiProv.dokterList.firstWhere(
                    (d) => d.namaLengkap == val,
                  );

                  setState(() {
                    selectedKodeDokter = dokter.kodeDokter;
                  });

                  reservasiProv.setSelectedDokter(dokter);

                  // Fetch tanggal dengan jadwal berdasarkan dokter yang dipilih
                  List<Map<String, dynamic>> rawDates;
                  if (selectedKodePoli != null) {
                    rawDates = await reservasiProv.fetchTanggalDenganJadwal(
                      kodePoli: selectedKodePoli!,
                      kodeDokter: selectedKodeDokter,
                    );
                  } else {
                    // Jika poli belum dipilih, hanya filter berdasarkan dokter
                    rawDates = await reservasiProv.fetchTanggalDenganJadwal(
                      kodeDokter: selectedKodeDokter,
                    );
                  }
                  availableDates = rawDates
                      .map((e) => e['tanggal'] as String)
                      .toList();

                  if (selectedTanggal != null &&
                      !availableDates.contains(selectedTanggal)) {
                    setState(() {
                      selectedTanggal = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 25),

              // DATE FIELD
              CustomDateField(
                label: "Pilih Tanggal",
                displayedDate: selectedTanggal != null
                    ? formatDateForDisplay(selectedTanggal!)
                    : null,
                onTap: () async {
                  // Jangan tampilkan date picker jika tidak ada tanggal yang tersedia
                  if (availableDates.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tidak ada tanggal yang tersedia untuk dipilih.",
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  final filteredFirstDate = DateTime.now();
                  final filteredLastDate = DateTime.now().add(
                    const Duration(
                      days: 7,
                    ), // Menampilkan 7 hari ke depan sesuai perubahan backend
                  );

                  // Tentukan initialDate berdasarkan tanggal yang tersedia
                  DateTime initialDate = DateTime.now();

                  // Jika selectedTanggal tidak null dan tersedia, gunakan itu
                  if (selectedTanggal != null &&
                      availableDates.contains(selectedTanggal)) {
                    initialDate = DateTime.parse(selectedTanggal!);
                  }
                  // Jika tidak, gunakan tanggal pertama dari availableDates
                  else if (availableDates.isNotEmpty) {
                    initialDate = DateTime.parse(availableDates.first);
                  }

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: filteredFirstDate,
                    lastDate: filteredLastDate,
                    selectableDayPredicate: (DateTime date) {
                      if (availableDates.isEmpty) return true;
                      final dateString = DateFormat('yyyy-MM-dd').format(date);
                      return availableDates.contains(dateString);
                    },
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.gold,
                            onPrimary: AppColors.textLight,
                            onSurface: AppColors.textLight,
                            surface: AppColors.cardWarm,
                          ),
                          dialogBackgroundColor: AppColors.cardWarm,
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (picked != null) {
                    final formattedDate = formatDateForApi(picked);
                    setState(() {
                      selectedTanggal = formattedDate;
                    });

                    // Fetch dokter dengan jadwal berdasarkan tanggal yang dipilih
                    if (selectedKodePoli != null) {
                      final rawDocs = await reservasiProv
                          .fetchDokterDenganJadwal(
                            kodePoli: selectedKodePoli!,
                            tanggalReservasi: formattedDate,
                          );
                      availableDoctors = rawDocs
                          .map((e) => e['kode_dokter'] as String)
                          .toList();

                      if (selectedKodeDokter != null &&
                          !availableDoctors.contains(selectedKodeDokter)) {
                        setState(() {
                          selectedKodeDokter = null;
                        });
                        reservasiProv.setSelectedDokter(null);
                      }
                    }
                  }
                },
              ),

              const SizedBox(height: 40),

              // BUTTON CEK JADWAL
              AuthButton(
                text: "Cek Jadwal",
                onPressed: (selectedKodePoli != null)
                    ? () async {
                        await reservasiProv.fetchJadwal(
                          kodePoli: selectedKodePoli!,
                          kodeDokter: selectedKodeDokter,
                          tanggalReservasi: selectedTanggal,
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
                      }
                    : null,
              ),

              const SizedBox(height: 25),

              // LIST JADWAL CARD
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

                      String namaDokterTampil = jadwal.kodeDokter;
                      try {
                        final dokterObj = prov.dokterList.firstWhere(
                          (d) => d.kodeDokter == jadwal.kodeDokter,
                        );
                        namaDokterTampil = dokterObj.namaLengkap;
                      } catch (_) {
                        namaDokterTampil = "Dokter ${jadwal.kodeDokter}";
                      }

                      bool isAvailable = jadwal.statusJadwal == 'Tersedia';

                      String namaPoliTampil =
                          prov.selectedPoli?.namaPoli ?? jadwal.kodePoli;
                      if (selectedKodePoli == null) {
                        try {
                          final poliObj = prov.poliList.firstWhere(
                            (p) => p.kodePoli == jadwal.kodePoli,
                          );
                          namaPoliTampil = poliObj.namaPoli;
                        } catch (_) {
                          namaPoliTampil = "Poli ${jadwal.kodePoli}";
                        }
                      }

                      // Gunakan tanggal_jadwal_harian jika tersedia, jika tidak gunakan tanggal yang dipilih
                      // Format tanggal tanpa nama hari untuk menghindari duplikasi dengan variabel 'hari'
                      String displayTanggal = selectedTanggal != null
                          ? DateFormat(
                              'd MMMM yyyy',
                              'id_ID',
                            ).format(DateTime.parse(selectedTanggal!))
                          : jadwal.tanggalJadwalHarian != null
                          ? DateFormat('d MMMM yyyy', 'id_ID').format(
                              DateTime.parse(jadwal.tanggalJadwalHarian!),
                            )
                          : '';

                      return Opacity(
                        opacity: isAvailable ? 1.0 : 0.6,
                        child: ScheduleCardWidget(
                          namaPoli: namaPoliTampil,
                          namaDokter: namaDokterTampil,
                          hari: jadwal.hari,
                          jam: "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                          quota: jadwal.quota,
                          kuotaTerpakai: jadwal.kuotaTerpakai,
                          tanggal: displayTanggal,
                          statusJadwal:
                              jadwal.statusJadwal, // Tambahkan status jadwal
                          onTap: () {
                            if (selectedTanggal == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Mohon pilih tanggal terlebih dahulu.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (!isAvailable) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Maaf, jadwal ini ${jadwal.statusJadwal}.",
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
                                  poli: namaPoliTampil,
                                  dokter: namaDokterTampil,
                                  tanggal:
                                      displayTanggal, // Gunakan tanggal yang sesuai
                                  jam:
                                      "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                                  keluhan: "-",
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
