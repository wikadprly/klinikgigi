import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/button.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/custom_date_field.dart';
import 'package:flutter_klinik_gigi/features/reservasi/widgets/custom_dropdown_field.dart';
import 'package:flutter_klinik_gigi/providers/reservasi_provider.dart';

class ReservasiScreen extends StatefulWidget {
  const ReservasiScreen({super.key});

  @override
  State<ReservasiScreen> createState() => _ReservasiScreenState();
}

class _ReservasiScreenState extends State<ReservasiScreen> {
  String? selectedPoli;
  String? selectedDokter;
  String? selectedTanggal;
  final String namaPasien = "Farel Sheva Basudewa";
  final String noRekamMedis = "11100000";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ReservasiProvider>(context, listen: false);
      await provider.fetchPoli();
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ReservasiProvider>(
        builder: (context, prov, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER KUSTOM
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textLight,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // WARNA TEKS PASIEN DIUBAH MENJADI KUNING (AppColors.gold)
                    Text(
                      namaPasien,
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 20,
                        color: AppColors.gold, // <--- Perubahan di sini
                      ),
                    ),
                    Text(
                      "No. Rekam Medis: $noRekamMedis",
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      // WARNA TEKS JUDUL DIUBAH MENJADI KUNING (AppColors.gold)
                      child: Text(
                        "Pilih Jadwal Periksa",
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 20,
                          color: AppColors.gold, // <--- Perubahan di sini
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PILIH POLI
                      Text("Pilih Poli", style: AppTextStyles.heading),
                      const SizedBox(height: 8),

                      CustomDropdownField(
                        label: "Pilih Semua",
                        items: prov.poliList.map((e) => e.namaPoli).toList(),
                        value: selectedPoli,
                        onChanged: (val) async {
                          if (val == null) return;

                          setState(() {
                            selectedPoli = val;
                            selectedDokter = null;
                            selectedTanggal = null;
                          });

                          final poli = prov.poliList.firstWhere(
                            (p) => p.namaPoli == val,
                          );

                          await prov.fetchDokterByPoli(poli.kodePoli);
                        },
                      ),

                      const SizedBox(height: 25),

                      // PILIH DOKTER
                      Text("Pilih Dokter", style: AppTextStyles.heading),
                      const SizedBox(height: 8),

                      CustomDropdownField(
                        label: "Pilih Semua Dokter",
                        items: prov.dokterList
                            .map((e) => e.gelar.isNotEmpty
                                ? "${e.nama}, ${e.gelar}"
                                : e.nama)
                            .toList(),
                        value: selectedDokter == null
                            ? null
                            : prov.dokterList
                                .where((d) => d.kodeDokter == selectedDokter)
                                .map((d) => d.gelar.isNotEmpty
                                    ? "${d.nama}, ${d.gelar}"
                                    : d.nama)
                                .first,
                        onChanged: (val) {
                          if (val == null) return;

                          final dokter = prov.dokterList.firstWhere(
                            (d) =>
                                (d.gelar.isNotEmpty
                                    ? "${d.nama}, ${d.gelar}"
                                    : d.nama) ==
                                val,
                          );

                          setState(() {
                            selectedDokter = dokter.kodeDokter;
                            selectedTanggal = null;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      // PILIH TANGGAL
                      Text("Pilih Tanggal", style: AppTextStyles.heading),
                      const SizedBox(height: 8),

                      CustomDateField(
                        label: "",
                        displayedDate: selectedTanggal,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 90)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.gold,
                                    onSurface: AppColors.textLight,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            final tanggalAPI = formatDate(picked);

                            setState(() {
                              selectedTanggal = tanggalAPI;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 40),

                      // BUTTON CEK JADWAL
                      AuthButton(
                        text: "Cek Jadwal",
                        onPressed: (selectedPoli == null ||
                                selectedDokter == null ||
                                selectedTanggal == null)
                            ? null
                            : () async {
                                final poli = prov.poliList.firstWhere(
                                  (p) => p.namaPoli == selectedPoli,
                                );

                                await prov.fetchJadwal(
                                  selectedDokter!,
                                  selectedTanggal!,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Mencari Jadwal Dokter..."),
                                    backgroundColor: AppColors.gold,
                                  ),
                                );
                              },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
