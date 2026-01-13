import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:http/http.dart' as http;
import '../widgets/riwayat_card.dart';
import '../widgets/homecare_riwayat_card.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Map<String, dynamic>> riwayatData = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedCare = 'poliklinik';

  Widget careToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        children: [
          _toggleItem(title: 'Poliklinik Care', value: 'poliklinik'),
          _toggleItem(title: 'Home Care', value: 'homecare'),
        ],
      ),
    );
  }

  Widget _toggleItem({required String title, required String value}) {
    final isActive = selectedCare == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCare = value;
            isLoading = true;
            errorMessage = null;
          });
          fetchRiwayat();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.goldDark : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.black : AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  // 🟦 Fungsi ambil data dari Laravel API dengan filter user yang login
  Future<void> fetchRiwayat() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      // Ambil user (opsional) dan token dari SharedPreferences
      final user = await SharedPrefsHelper.getUser();
      final token = await SharedPrefsHelper.getToken();

      if (token == null) {
        if (kDebugMode) {
          print('DEBUG: Token null atau tidak tersedia');
          print('DEBUG: User: $user');
        }
        setState(() {
          errorMessage = "Token tidak tersedia. Silakan login kembali.";
          isLoading = false;
        });
        return;
      }

      if (kDebugMode) {
        print('DEBUG: Token diterima: $token');
        if (user != null) {
          try {
            print('DEBUG: User ID: ${user.userId}');
            print('DEBUG: Rekam Medis ID: ${user.rekamMedisId}');
          } catch (_) {}
        }
      }

      // Panggil API dengan token (API sekarang sudah terproteksi dengan auth:sanctum)
      // Append filter for jenis layanan (poliklinik/homecare)
      final uri = Uri.parse(
        'http://pbl250116.informatikapolines.id/api/riwayat',
      ).replace(queryParameters: {'jenis': selectedCare});

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (kDebugMode) {
        print('DEBUG: Response Status: ${response.statusCode}');
        print('DEBUG: Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (kDebugMode) {
          print('DEBUG: Decoded Response: $decoded');
        }

        // Jika response memiliki struktur { success: true, data: [...] }
        List<dynamic> data = decoded is Map ? (decoded["data"] ?? []) : decoded;

        if (kDebugMode) {
          print('DEBUG: Data length: ${data.length}');
        }

        setState(() {
          riwayatData = data.map((item) {
            // Ambil data waktu layanan dan biaya dari relasi `reservasi` jika tersedia,
            // kalau tidak fallback ke field top-level
            final reservasi = item["reservasi"] ?? {};
            return {
              // Basic
              "jenis_layanan":
                  item["jenis_layanan"] ?? item["jenis"] ?? "poliklinik",

              // Informasi reservasi
              "no_pemeriksaan": item["no_pemeriksaan"] ?? "-",
              "dokter": item["dokter"] ?? "-",
              "tanggal": item["tanggal"] ?? "-",
              "poli": item["poli"] ?? "-",
              "status_reservasi": item["status_reservasi"] ?? "-",
              "jam_mulai": item["jam_mulai"] ?? reservasi["jam_mulai"] ?? "-",
              "jam_selesai":
                  item["jam_selesai"] ?? reservasi["jam_selesai"] ?? "-",

              // Biaya (support homecare fields)
              "biaya":
                  item["biaya"] ??
                  reservasi["biaya"] ??
                  item["pembayaran_total"] ??
                  "0",
              "biaya_reservasi": item["biaya_reservasi"] ?? "0",
              "biaya_transport": item["biaya_transport"] ?? "0",
              "pembayaran_total":
                  item["pembayaran_total"] ??
                  item["pembayaran_total"] ??
                  item["biaya"] ??
                  "0",

              // Payment
              "metode_pembayaran": item["metode_pembayaran"] ?? "-",

              // Payment links (added to support redirect_url and link_pembayaran)
              "redirect_url": item["redirect_url"] ?? "-",
              "link_pembayaran": item["link_pembayaran"] ?? "-",
              "snap_token": item["snap_token"] ?? "-",

              // Payment availability (whether payment button is still available)
              "payment_available": item["payment_available"] ?? true,

              // Created at timestamp
              "created_at": item["created_at"] ?? null,

              // Informasi pasien
              "nama": item["nama"] ?? "-",
              "rekam_medis":
                  item["rekam_medis"] ?? item["no_rekam_medis"] ?? "-",
              "no_rekam_medis":
                  item["no_rekam_medis"] ?? item["rekam_medis"] ?? "-",
              "foto": item["foto"] ?? "",

              // status pembayaran & booking
              "status": item["status_pembayaran"] ?? item["status"] ?? "-",
              "statusreservasi": item["status_reservasi"] ?? "-",
              "status_booking": item["status_booking"] ?? "-",

              "no_antrian": item["no_antrian"] ?? "-",
              "keluhan": item["keluhan"] ?? "-",
            };
          }).toList();
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage =
              "Sesi login Anda telah berakhir. Silakan login kembali.";
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              "Gagal memuat data. Status Code: ${response.statusCode}\nResponse: ${response.body}";
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('DEBUG: Exception: $e');
      }
      setState(() {
        errorMessage = "Terjadi kesalahan: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Riwayat", style: AppTextStyles.heading),
              const SizedBox(height: 12),

              careToggle(),

              const SizedBox(height: 16),

              // 🟡 Loading atau Error Handler
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                )
              else if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (riwayatData.isEmpty)
                const Center(
                  child: Text(
                    "Belum ada riwayat reservasi.",
                    style: TextStyle(color: AppColors.goldDark),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    // give extra bottom padding so the last card isn't hidden
                    // by the app's bottom navigation overlay
                    padding: const EdgeInsets.only(bottom: 110),
                    itemCount: riwayatData.length,
                    itemBuilder: (context, index) {
                      final data = riwayatData[index];

                      final jenis = (data["jenis_layanan"] ?? "poliklinik")
                          .toString()
                          .toLowerCase();
                      if (jenis == 'homecare' || jenis == 'home') {
                        return HomeCareRiwayatCard(
                          noPemeriksaan: (data["no_pemeriksaan"] ?? "-")
                              .toString(),
                          dokter: (data["dokter"] ?? "-").toString(),
                          jamMulai: (data["jam_mulai"] ?? "-").toString(),
                          jamSelesai: (data["jam_selesai"] ?? "-").toString(),
                          pembayaranTotal:
                              (data["pembayaran_total"] ?? data["biaya"] ?? "0")
                                  .toString(),
                          metodePembayaran: (data["metode_pembayaran"] ?? "-")
                              .toString(),
                          statusReservasi: (data["status_reservasi"] ?? "-")
                              .toString(),
                          data: data,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/riwayat_detail',
                              arguments: data,
                            );
                          },
                        );
                      }

                      return RiwayatCard(
                        noPemeriksaan: (data["no_pemeriksaan"] ?? "-")
                            .toString(),
                        noAntrian: (data["no_antrian"] ?? "Menunggu Pembayaran")
                            .toString(),
                        dokter: (data["dokter"] ?? "-").toString(),
                        tanggal: (data["tanggal"] ?? "-").toString(),
                        poli: (data["poli"] ?? "-").toString(),
                        statusReservasi: (data["status_reservasi"] ?? "-")
                            .toString(),
                        data: data,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/riwayat_detail',
                            arguments: data,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
