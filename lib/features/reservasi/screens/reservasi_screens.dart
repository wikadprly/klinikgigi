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
              // HEADER — sekarang ikut scroll
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

                  await reservasiProv.fetchDokterByPoli(poli.kodePoli);
                },
              ),

              const SizedBox(height: 25),

              // =============================================================
              // PILIH DOKTER
              // =============================================================
              Text(
                "Pilih Dokter",
                style: AppTextStyles.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),

              CustomDropdownField(
                label: "Pilih Dokter",
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
                    selectedTanggal = null;
                  });
                },
              ),

              const SizedBox(height: 25),

              // =============================================================
              // PILIH TANGGAL
              // =============================================================
              Text(
                "Pilih Tanggal",
                style: AppTextStyles.label.copyWith(color: AppColors.gold),
              ),
              const SizedBox(height: 8),

              CustomDateField(
                label: "Pilih Tanggal",
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
                onPressed:
                    (selectedKodePoli == null ||
                        selectedKodeDokter == null ||
                        selectedTanggal == null)
                    ? null
                    : () async {
                        await reservasiProv.fetchJadwal(
                          kodeDokter: selectedKodeDokter!,
                          kodePoli: selectedKodePoli!,
                          tanggalReservasi: selectedTanggal!,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Mengambil jadwal dokter..."),
                            backgroundColor: AppColors.gold,
                          ),
                        );
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
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Tidak ada jadwal tersedia.",
                        style: AppTextStyles.label,
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prov.jadwalList.length,
                    itemBuilder: (context, index) {
                      final jadwal = prov.jadwalList[index];

                      return ScheduleCardWidget(
                        namaPoli: jadwal.namaPoli,
                        namaDokter: jadwal.namaDokter,
                        hari: jadwal.hari,
                        jam: "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                        kuotaSisa: jadwal.sisaKuota,
                        kuotaTotal: jadwal.kuotaTotal,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) {
                              return KonfirmasiReservasiSheet(
                                namaPasien: user?.namaPengguna ?? "-",
                                rekamMedis:
                                    user?.rekamMedisId.toString() ?? "-",
                                poli: jadwal.namaPoli,
                                dokter: jadwal.namaDokter,
                                tanggal: selectedTanggal!,
                                jam:
                                    "${jadwal.jamMulai} - ${jadwal.jamSelesai}",
                                keluhan: "-",
                                total: 25000,
                              );
                            },
                          );
                        },
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
