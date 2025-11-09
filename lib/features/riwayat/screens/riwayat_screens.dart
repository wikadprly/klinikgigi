import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_klinik_gigi/theme/colors.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<dynamic> riwayatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/riwayat'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          riwayatList = data;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Riwayat",
          style: TextStyle(color: AppColors.goldDark),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.goldDark),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final item = riwayatList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.goldDark, width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.background.withOpacity(0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            item['status'] == 'selesai'
                                ? Icons.circle
                                : Icons.circle_outlined,
                            color: item['status'] == 'selesai'
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "No. Pemeriksaan : ",
                            style: TextStyle(
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${item['no_pemeriksaan']}",
                            style: const TextStyle(
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Dokter : ${item['dokter_id']}",
                        style: const TextStyle(color: AppColors.goldDark),
                      ),
                      Text(
                        "Tanggal : ${item['tanggal_pesan']}",
                        style: const TextStyle(color: AppColors.goldDark),
                      ),
                      Text(
                        "Poli : ${item['poli']}",
                        style: const TextStyle(color: AppColors.goldDark),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
