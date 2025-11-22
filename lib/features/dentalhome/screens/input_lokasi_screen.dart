import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Optional: untuk ubah koordinat jadi nama jalan
import '../../../../core/services/home_care_service.dart';
import 'pembayaran_homecare_screen.dart'; // Kita buat setelah ini

class InputLokasiScreen extends StatefulWidget {
  // Data yang dikirim dari halaman sebelumnya (Pilih Dokter)
  final int masterJadwalId;
  final String tanggal; // Format YYYY-MM-DD
  final String namaDokter;
  final String jamPraktek;

  const InputLokasiScreen({
    Key? key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
  }) : super(key: key);

  @override
  State<InputLokasiScreen> createState() => _InputLokasiScreenState();
}

class _InputLokasiScreenState extends State<InputLokasiScreen> {
  final HomeCareService _service = HomeCareService();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  Map<String, dynamic>? _estimasiBiaya; // Menyimpan hasil dari API

  // Fungsi Ambil Lokasi GPS
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Cek Permission GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      // Ambil Posisi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      // Optional: Ambil nama jalan dari koordinat (Reverse Geocoding)
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          _alamatController.text =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        }
      } catch (e) {
        // Abaikan jika gagal dapat nama jalan, user bisa ketik manual
      }

      // Panggil API Laravel untuk hitung ongkir
      final result = await _service.calculateCost(_latitude!, _longitude!);

      setState(() {
        _estimasiBiaya = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengambil lokasi: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _lanjutKePembayaran() {
    if (_latitude == null || _estimasiBiaya == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon ambil lokasi terlebih dahulu")),
      );
      return;
    }

    // Pindah ke halaman Pembayaran membawa semua data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranHomeCareScreen(
          masterJadwalId: widget.masterJadwalId,
          tanggal: widget.tanggal,
          namaDokter: widget.namaDokter,
          jamPraktek: widget.jamPraktek,
          keluhan: _keluhanController.text,
          alamat: _alamatController.text,
          latitude: _latitude!,
          longitude: _longitude!,
          rincianBiaya: _estimasiBiaya!, // Data biaya dari API
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lokasi & Keluhan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Keluhan Gigi", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _keluhanController,
              decoration: InputDecoration(
                hintText: "Contoh: Gigi geraham sakit nyut-nyutan",
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),

            Text(
              "Lokasi Kunjungan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Tombol Ambil Lokasi
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.my_location),
              label: Text(
                _isLoading
                    ? "Sedang Menghitung..."
                    : "Gunakan Lokasi Saya Saat Ini",
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            SizedBox(height: 10),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(
                labelText: "Detail Alamat / Patokan",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            // Tampilkan Hasil Estimasi jika sudah ada
            if (_estimasiBiaya != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rincian Biaya Perjalanan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Jarak ke Klinik"),
                        Text(
                          "${_estimasiBiaya!['jarak_km']} km",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Biaya Transport"),
                        Text(
                          "Rp ${_estimasiBiaya!['biaya_transport']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _estimasiBiaya != null ? _lanjutKePembayaran : null,
              child: Text("Lanjut ke Pembayaran"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple, // Sesuaikan tema
              ),
            ),
          ],
        ),
      ),
    );
  }
}
