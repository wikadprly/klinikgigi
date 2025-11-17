import 'package:flutter/material.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          "Riwayat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== PROFILE PASIEN =====
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    data['foto'] ?? "https://via.placeholder.com/150",
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama : ${data['nama']}",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "NO.RM : ${data['rekam_medis']}",
                      style: const TextStyle(
                        color: Colors.white70, 
                        fontSize: 14
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 25),

            // ===== CARD DETAIL =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF2A2A2A),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildRowBold("No. Pemeriksaan :", data['no_pemeriksaan'] ?? "-"),

                  const SizedBox(height: 12),

                  _buildRow("Waktu Layanan", "${data['jam_mulai']} - ${data['jam_selesai']}"),
                  _buildRow("Hari/Tanggal", data['tanggal'] ?? "-"),
                  _buildRow("Dokter", data['dokter'] ?? "-"),
                  _buildRow("Poli", data['poli'] ?? "-"),
                  _buildRow("Catatan Dokter", data['catatan'] ?? "-"),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        "Status Reservasi",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data['status'] ?? "-",
                        style: TextStyle(
                          color: (data['status'] == "Selesai")
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TOTAL BIAYA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Biaya :",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15
                        ),
                      ),
                      Text(
                        "Rp.${data['biaya']}",
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // BUTTON KEMBALI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4D97D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Kembali",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold