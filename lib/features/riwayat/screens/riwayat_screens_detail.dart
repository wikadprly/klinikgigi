import 'package:flutter/material.dart';

class RiwayatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RiwayatDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Provide default values untuk safety
    final nama = data['nama'] as String? ?? "-";
    final rekamMedis = data['rekam_medis'] as String? ?? "-";
    final foto = data['foto'] as String? ?? "https://via.placeholder.com/150";
    final noPemeriksaan = data['no_pemeriksaan'] as String? ?? "-";
    final jamMulai = data['jam_mulai'] as String? ?? "-";
    final jamSelesai = data['jam_selesai'] as String? ?? "-";
    final tanggal = data['tanggal'] as String? ?? "-";
    final dokter = data['dokter'] as String? ?? "-";
    final poli = data['poli'] as String? ?? "-";
    final catatan = data['catatan'] as String? ?? "-";
    final status =
        data['status'] as String? ?? data['status_reservasi'] as String? ?? "-";
    final biaya = data['biaya'] as String? ?? "0";

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          "Detail Riwayat",
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
                  backgroundColor: const Color(0xFF2A2A2A),
                  backgroundImage:
                      foto.isNotEmpty &&
                          foto != "https://via.placeholder.com/150"
                      ? NetworkImage(foto)
                      : null,
                  child:
                      foto.isEmpty || foto == "https://via.placeholder.com/150"
                      ? const Icon(Icons.person, color: Colors.grey, size: 35)
                      : null,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama : $nama",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NO.RM : $rekamMedis",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  _buildRowBold("No. Pemeriksaan :", noPemeriksaan),

                  const SizedBox(height: 12),

                  _buildRow("Waktu Layanan", "$jamMulai - $jamSelesai"),
                  _buildRow("Hari/Tanggal", tanggal),
                  _buildRow("Dokter", dokter),
                  _buildRow("Poli", poli),
                  _buildRow("Catatan Dokter", catatan),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        "Status Reservasi",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          status,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: (status.toLowerCase() == "selesai")
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
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
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      Text(
                        "Rp.$biaya",
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==== COMPONENT HOLDER ====

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.yellow, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowBold(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
