import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/home_care_service.dart';

class InputLokasiScreen extends StatefulWidget {
  // Data yang dikirim dari halaman sebelumnya (Pilih Dokter)
  final int masterJadwalId;
  final String tanggal; // Format YYYY-MM-DD
  final String namaDokter;
  final String jamPraktek;

  const InputLokasiScreen({
    super.key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
  });

  @override
  State<InputLokasiScreen> createState() => _InputLokasiScreenState();
}

class _InputLokasiScreenState extends State<InputLokasiScreen> {
  final HomeCareService _service = HomeCareService();
  final TextEditingController _alamatController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  Map<String, dynamic>? _estimasiBiaya; // Menyimpan hasil dari API

  // Flutter Map variables
  late MapController _mapController;
  LatLng? _centerLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Set default location ke null atau biarkan kosong dulu
    _centerLocation = null;

    // Ambil lokasi pengguna secara otomatis saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  // Fungsi Ambil Lokasi GPS
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Periksa & minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Izin lokasi ditolak. Mohon aktifkan izin lokasi untuk aplikasi ini.",
              ),
            ),
          );
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Izin lokasi ditolak secara permanen. Mohon aktifkan izin lokasi melalui pengaturan aplikasi.",
              ),
            ),
          );
        }
        return;
      }

      // Ambil dua posisi untuk memilih yang lebih akurat
      Position pos1 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Position pos2 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      // Pilih posisi dengan akurasi lebih baik
      Position finalPos = pos1.accuracy < pos2.accuracy ? pos1 : pos2;

      // Pindahkan peta ke lokasi yang dipilih
      _mapController.move(LatLng(finalPos.latitude, finalPos.longitude), 16.0);

      setState(() {
        _latitude = finalPos.latitude;
        _longitude = finalPos.longitude;
        _centerLocation = LatLng(finalPos.latitude, finalPos.longitude);
      });

      // Update lat-lng + reverse geocode + estimasi biaya
      await _updateLocationAndCalculate(finalPos.latitude, finalPos.longitude);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengambil lokasi: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Fungsi untuk mengupdate lokasi dan menghitung estimasi biaya
  Future<void> _updateLocationAndCalculate(double lat, double lng) async {
    _latitude = lat;
    _longitude = lng;

    // Ambil nama jalan dari koordinat (Reverse Geocoding)
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}"
                .trim();
        _alamatController.text = fullAddress.isEmpty
            ? "Lokasi (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})"
            : fullAddress;
      }
    } catch (e) {
      // Jika gagal dapat nama jalan, gunakan format default
      _alamatController.text =
          "Lokasi (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})";
    }

    // Panggil API Laravel untuk hitung ongkir dengan error handling yang lebih baik
    try {
      final result = await _service.calculateCost(lat, lng);

      if (mounted) {
        setState(() {
          _estimasiBiaya = result;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Gagal menghitung estimasi biaya";

        // Jika error berisi HTML (seperti error page Laravel), tampilkan pesan generik
        if (e.toString().contains('<!DOCTYPE html>')) {
          errorMessage =
              "Terjadi kesalahan pada server, silakan coba lagi nanti.";
        } else {
          errorMessage =
              "Gagal menghitung estimasi biaya: ${e.toString().split('.').first}";
        }

        // Tampilkan error jika perhitungan gagal
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        // Kosongkan estimasi biaya jika error
        setState(() {
          _estimasiBiaya = null;
        });
      }
    }
  }

  // Fungsi untuk memindahkan peta ke lokasi tertentu
  void _moveToLocation(double lat, double lng) {
    try {
      _mapController.move(LatLng(lat, lng), 15.0);
      setState(() {
        _centerLocation = LatLng(lat, lng);
      });
    } catch (e) {
      // Jika terjadi error saat memindahkan peta, log error tapi jangan crash
      print('Error moving map: $e');
    }
  }

  // Fungsi untuk menghitung ulang estimasi dari lokasi tengah peta saat ini
  void _updateEstimationFromMapCenter() {
    try {
      final camera = _mapController.camera;
      if (camera != null) {
        final center = camera.center;
        _updateLocationAndCalculate(center.latitude, center.longitude);
      } else if (_centerLocation != null) {
        // Fallback ke lokasi yang terakhir diketahui
        _updateLocationAndCalculate(
          _centerLocation!.latitude,
          _centerLocation!.longitude,
        );
      }
    } catch (e) {
      print('Error updating estimation from map center: $e');
    }
  }

  void _lanjutKePembayaran() {
    if (_latitude == null || _estimasiBiaya == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon ambil lokasi terlebih dahulu")),
        );
      }
      return;
    }

    // Pindah ke halaman Pembayaran membawa semua data using named routes
    // Field keluhan dihapus karena tidak lagi digunakan
    Navigator.pushNamed(
      context,
      '/dentalhome/pembayaran',
      arguments: {
        'masterJadwalId': widget.masterJadwalId,
        'tanggal': widget.tanggal,
        'namaDokter': widget.namaDokter,
        'jamPraktek': widget.jamPraktek,
        'keluhan':
            "Permintaan kunjungan home care", // Field keluhan dihapus, gunakan default value
        'alamat': _alamatController
            .text, // Alamat sudah ditentukan di _updateLocationAndCalculate
        'latitude': _latitude!,
        'longitude': _longitude!,
        'rincianBiaya': _estimasiBiaya!, // Data biaya dari API
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        title: const Text("Pin Lokasi di Peta", style: AppTextStyles.heading),
      ),
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.only(
              bottom: 80,
            ), // Space for bottom button
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Instruction subtitle
                Text(
                  "Geser peta untuk menentukan lokasi kunjungan Anda",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),

                // Map Widget with Flutter Map (OpenStreetMap)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter:
                            _centerLocation ??
                            const LatLng(
                              -0.7893,
                              113.9213,
                            ), // Default ke Indonesia (akan segera diganti oleh GPS)
                        initialZoom: 15.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        onPositionChanged: (pos, hasGesture) {
                          if (hasGesture && pos.center != null) {
                            _centerLocation = pos.center;
                            setState(() {});
                          }

                          // Jika selesai geser peta, hitung ulang estimasi//
                          if (!hasGesture && pos.center != null) {
                            _updateLocationAndCalculate(
                              pos.center!.latitude,
                              pos.center!.longitude,
                            );
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(
                          markers: [
                            if (_centerLocation != null)
                              Marker(
                                width: 50.0,
                                height: 50.0,
                                point: _centerLocation!,
                                child: Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(
                                    255,
                                    255,
                                    0,
                                    0,
                                  ), // Gold color
                                  size: 40,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Petunjuk penggunaan peta
                Text(
                  "Gunakan tombol di bawah untuk mengatur lokasi",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 8),

                const SizedBox(height: 8),

                // Tombol untuk menghitung ulang estimasi dari lokasi tengah peta saat ini
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : _updateEstimationFromMapCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate, color: AppColors.gold, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Hitung Ulang Estimasi",
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Instruksi untuk pengguna
                Text(
                  "Geser peta untuk menyesuaikan lokasi, lalu tekan 'Hitung Ulang Estimasi'",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 8),

                const SizedBox(height: 20),

                // "Gunakan Lokasi saat ini" button - mengambil lokasi dari GPS dan pindahkan peta ke sana
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location,
                          color: AppColors.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isLoading
                              ? "Mengambil Lokasi..."
                              : "Gunakan Lokasi Anda Saat Ini",
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Alamat Lokasi (auto-filled, tidak dapat diedit)
                Text(
                  "Alamat Lokasi",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: TextField(
                    controller: _alamatController,
                    readOnly: true, // Hanya untuk tampilan, tidak bisa diedit
                    decoration: const InputDecoration(
                      hintText:
                          "Alamat akan otomatis terisi setelah memilih lokasi",
                      hintStyle: TextStyle(
                        color: Color(0xFF8D8D8D),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: AppTextStyles.input,
                  ),
                ),

                const SizedBox(height: 20),

                // Estimasi Jarak & Biaya Card
                if (_estimasiBiaya != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.gold,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Estimasi Jarak & Biaya",
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jarak ke Klinik", style: AppTextStyles.label),
                            Text(
                              "${_estimasiBiaya!['jarak_km']} km",
                              style: AppTextStyles.input.copyWith(
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Biaya Transportasi",
                              style: AppTextStyles.label,
                            ),
                            Text(
                              "Rp ${_estimasiBiaya!['biaya_transport']}",
                              style: TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Sticky Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.inputBorder)),
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: _estimasiBiaya != null
                      ? _lanjutKePembayaran
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Konfirmasi Alamat", style: AppTextStyles.button),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
