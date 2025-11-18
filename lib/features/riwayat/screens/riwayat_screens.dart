import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:http/http.dart' as http;
import '../widgets/riwayat_card.dart';
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

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  // 🟦 Fungsi ambil data dari Laravel API dengan filter user yang login
  Future<void> fetchRiwayat() async {
    try {
      // Ambil user dan token dari SharedPreferences
      final user = await SharedPrefsHelper.getUser();

      if (user == null || user.token == null) {
        if (kDebugMode) {
          print('DEBUG: User atau token null');
          print('User: $user');
        }
        setState(() {
          errorMessage =
              "User tidak ditemukan atau token tidak tersedia. Silakan login kembali.";
          isLoading = false;
        });
        return;
      }

      final token = user.token;
      if (kDebugMode) {
        print('DEBUG: Token diterima: $token');
        print('DEBUG: User ID: ${user.userId}');
        print('DEBUG: Rekam Medis ID: ${user.rekamMedisId}');
      }

      // Panggil API dengan token (API sekarang sudah terproteksi dengan auth:sanctum)
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/riwayat'),
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
              // Informasi reservasi
              "no_pemeriksaan": item["no_pemeriksaan"] ?? "-",
              "dokter": item["dokter"] ?? "-",
              "tanggal": item["tanggal"] ?? "-",
              "poli": item["poli"] ?? "-",
              "status_reservasi": item["status_reservasi"] ?? "-",
              "jam_mulai": item["jam_mulai"] ?? reservasi["jam_mulai"] ?? "-",
              "jam_selesai":
                  item["jam_selesai"] ?? reservasi["jam_selesai"] ?? "-",
              "biaya": item["biaya"] ?? reservasi["biaya"] ?? "0",

              // Informasi pasien
              "nama": item["nama"] ?? "-",
              "rekam_medis":
                  item["rekam_medis"] ?? item["no_rekam_medis"] ?? "-",
              "no_rekam_medis":
                  item["no_rekam_medis"] ?? item["rekam_medis"] ?? "-",
              "foto": item["foto"] ?? "",
              "status": item["status_reservasi"] ?? "-",
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
              const Text(
                "Riwayat",
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 12),

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
                    itemCount: riwayatData.length,
                    itemBuilder: (context, index) {
                      final data = riwayatData[index];
                      return RiwayatCard(
                        noPemeriksaan: data["no_pemeriksaan"]!,
                        dokter: data["dokter"]!,
                        tanggal: data["tanggal"]!,
                        poli: data["poli"]!,
                        statusReservasi: data["status_reservasi"]!,
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
