import 'dart:convert';
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

  // 🟦 Fungsi ambil data dari Laravel API
  Future<void> fetchRiwayat() async {
    try {
      final token = await SharedPrefsHelper.getUser();

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/riwayat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded["data"]; // AMBIL DARI "data"

        setState(() {
          riwayatData = data
              .map(
                (item) => {
                  "no_pemeriksaan": item["no_pemeriksaan"],
                  "dokter": item["dokter"],
                  "tanggal": item["tanggal"],
                  "poli": item["poli"],
                  "status_reservasi": item["status_reservasi"],
                },
              )
              .toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal memuat data. Code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
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
