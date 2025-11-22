import 'package:flutter/material.dart';
import '../../../../core/services/home_care_service.dart';

class PembayaranHomeCareScreen extends StatefulWidget {
  final int masterJadwalId;
  final String tanggal;
  final String namaDokter;
  final String jamPraktek;
  final String keluhan;
  final String alamat;
  final double latitude;
  final double longitude;
  final Map<String, dynamic>
  rincianBiaya; // {'biaya_transport', 'biaya_layanan', 'estimasi_total'}

  const PembayaranHomeCareScreen({
    Key? key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
    required this.keluhan,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.rincianBiaya,
  }) : super(key: key);

  @override
  State<PembayaranHomeCareScreen> createState() =>
      _PembayaranHomeCareScreenState();
}

class _PembayaranHomeCareScreenState extends State<PembayaranHomeCareScreen> {
  final HomeCareService _service = HomeCareService();
  String _selectedPayment = 'transfer'; // Default
  bool _isProcessing = false;

  Future<void> _bayarSekarang() async {
    setState(() => _isProcessing = true);

    try {
      await _service.createBooking(
        masterJadwalId: widget.masterJadwalId,
        tanggal: widget.tanggal,
        keluhan: widget.keluhan,
        lat: widget.latitude,
        lng: widget.longitude,
        alamat: widget.alamat,
        metodePembayaran: _selectedPayment,
      );

      // Jika Sukses, Navigasi ke Halaman Sukses (bisa pakai dialog atau page baru)
      _showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal booking: $e")));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text(
          "Booking Berhasil!\nSilakan lakukan pembayaran sesuai metode yang dipilih.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Kembali ke Home Utama (Route harus disesuaikan dengan app Anda)
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/home', (route) => false);
            },
            child: Text("Kembali ke Beranda"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biaya = widget.rincianBiaya;
    final total = biaya['estimasi_total'];

    return Scaffold(
      appBar: AppBar(title: Text("Konfirmasi Pembayaran")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Ringkasan Dokter
            Card(
              child: ListTile(
                leading: Icon(Icons.medical_services, color: Colors.blue),
                title: Text(widget.namaDokter),
                subtitle: Text("${widget.tanggal} | ${widget.jamPraktek}"),
              ),
            ),
            SizedBox(height: 20),

            // Ringkasan Biaya
            Text(
              "Rincian Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildRow("Biaya Layanan Home Care", biaya['biaya_layanan']),
            _buildRow(
              "Biaya Transportasi (${biaya['jarak_km']} km)",
              biaya['biaya_transport'],
            ),
            Divider(),
            _buildRow("Total Tagihan", total, isTotal: true),

            SizedBox(height: 20),

            // Metode Pembayaran
            Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              value: 'transfer',
              groupValue: _selectedPayment,
              title: Text("Transfer Bank (BCA/Mandiri)"),
              onChanged: (val) =>
                  setState(() => _selectedPayment = val.toString()),
            ),
            RadioListTile(
              value: 'qris',
              groupValue: _selectedPayment,
              title: Text("QRIS (Gopay/Ovo/Dana)"),
              onChanged: (val) =>
                  setState(() => _selectedPayment = val.toString()),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isProcessing ? null : _bayarSekarang,
              child: Text(
                _isProcessing ? "Memproses..." : "Bayar & Konfirmasi",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, dynamic value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "Rp $value",
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
