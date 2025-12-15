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
  // Constructor dibuat kosong karena data diambil via Route Arguments
  const InputLokasiScreen({super.key});

  @override
  State<InputLokasiScreen> createState() => _InputLokasiScreenState();
}

class _InputLokasiScreenState extends State<InputLokasiScreen> {
  final HomeCareService _service = HomeCareService();
  final TextEditingController _alamatController = TextEditingController();

  // --- VARIABEL UNTUK MENAMPUNG DATA DARI JADWAL ---
  int? masterJadwalId;
  String? tanggal;
  String? namaDokter;
  String? jamPraktek;
  String? spesialis;
  String? jenisKeluhan; // NEW
  String? jenisKeluhanLainnya; // NEW

  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  Map<String, dynamic>? _estimasiBiaya;

  // Flutter Map variables
  late MapController _mapController;
  LatLng? _centerLocation;

  // Flag agar pengambilan argumen hanya dilakukan sekali
  bool _isInitData = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _centerLocation = null;

    // Ambil lokasi pengguna secara otomatis saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  // --- FUNGSI BARU: MENANGKAP ARGUMEN DARI NAVIGATOR ---
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitData) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        masterJadwalId = args['masterJadwalId'];
        tanggal = args['tanggal'];
        namaDokter = args['namaDokter'];
        jamPraktek = args['jamPraktek'];
        spesialis = args['spesialis'];
        jenisKeluhan = args['jenisKeluhan']; // Capture
        jenisKeluhanLainnya = args['jenisKeluhanLainnya']; // Capture
      }
      _isInitData = false;
    }
  }

  // Fungsi Ambil Lokasi GPS
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Izin lokasi ditolak.")));
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Izin lokasi ditolak permanen.")),
          );
        }
        return;
      }

      Position pos1 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Position pos2 = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      Position finalPos = pos1.accuracy < pos2.accuracy ? pos1 : pos2;

      _mapController.move(LatLng(finalPos.latitude, finalPos.longitude), 16.0);

      setState(() {
        _latitude = finalPos.latitude;
        _longitude = finalPos.longitude;
        _centerLocation = LatLng(finalPos.latitude, finalPos.longitude);
      });

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

  Future<void> _updateLocationAndCalculate(double lat, double lng) async {
    _latitude = lat;
    _longitude = lng;

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
      _alamatController.text =
          "Lokasi (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})";
    }

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
        if (e.toString().contains('<!DOCTYPE html>')) {
          errorMessage = "Terjadi kesalahan pada server.";
        } else {
          errorMessage = "Gagal menghitung: ${e.toString().split('.').first}";
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        setState(() => _estimasiBiaya = null);
      }
    }
  }

  void _moveToLocation(double lat, double lng) {
    try {
      _mapController.move(LatLng(lat, lng), 15.0);
      setState(() {
        _centerLocation = LatLng(lat, lng);
      });
    } catch (e) {
      debugPrint('Error moving map: $e');
    }
  }

  void _updateEstimationFromMapCenter() {
    try {
      final camera = _mapController.camera;
      final center = camera.center;
      _updateLocationAndCalculate(center.latitude, center.longitude);
    } catch (e) {
      debugPrint('Error updating estimation: $e');
    }
  }

  void _lanjutKePembayaran() {
    if (_latitude == null || _estimasiBiaya == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon ambil lokasi terlebih dahulu")),
      );
      return;
    }

    // Pindah ke halaman Pembayaran membawa semua data
    Navigator.pushNamed(
      context,
      '/dentalhome/pembayaran',
      arguments: {
        // Menggunakan variabel lokal yang sudah diisi dari didChangeDependencies
        'masterJadwalId': masterJadwalId,
        'tanggal': tanggal,
        'namaDokter': namaDokter,
        'jamPraktek': jamPraktek,
        'keluhan':
            jenisKeluhanLainnya ??
            jenisKeluhan ??
            "Permintaan kunjungan home care", // Fallback description
        'jenisKeluhan': jenisKeluhan, // Pass to next screen
        'jenisKeluhanLainnya': jenisKeluhanLainnya, // Pass to next screen
        'alamat': _alamatController.text,
        'latitude': _latitude!,
        'longitude': _longitude!,
        'rincianBiaya': _estimasiBiaya!,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Geser peta untuk menentukan lokasi kunjungan Anda",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),

                // Map Widget
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter:
                                _centerLocation ??
                                const LatLng(-0.7893, 113.9213),
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(
                              flags:
                                  InteractiveFlag.all & ~InteractiveFlag.rotate,
                            ),
                            // Update _centerLocation saat map digeser
                            onPositionChanged: (pos, hasGesture) {
                              if (hasGesture) {
                                _centerLocation = pos.center;
                              }
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            // MarkerLayer DIHAPUS, diganti Static Icon di Stack
                          ],
                        ),
                      ),
                      // STATIC CENTER PIN
                      // Icon ini diam di tengah, map yang bergerak di bawahnya
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 20.0,
                        ), // Offset agar ujung pin pas di tengah
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Tombol Hitung Ulang
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
                      children: const [
                        Icon(Icons.calculate, color: AppColors.gold, size: 16),
                        SizedBox(width: 6),
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
                Text(
                  "Geser peta untuk menyesuaikan lokasi, lalu tekan 'Hitung Ulang Estimasi'",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Lokasi Saat Ini
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
                        const Icon(
                          Icons.my_location,
                          color: AppColors.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isLoading
                              ? "Mengambil Lokasi..."
                              : "Gunakan Lokasi Anda Saat Ini",
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Alamat Lokasi",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: TextField(
                    controller: _alamatController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: "Alamat akan otomatis terisi...",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.gold,
                      ),
                    ),
                    style: AppTextStyles.input,
                  ),
                ),

                const SizedBox(height: 20),

                // Estimasi Biaya
                if (_estimasiBiaya != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.cardDark, AppColors.cardWarmDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jarak ke Klinik", style: AppTextStyles.label),
                            Row(
                              children: [
                                const Icon(
                                  Icons.straighten,
                                  color: AppColors.textMuted,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${(_estimasiBiaya!['jarak_km'] ?? 0).toStringAsFixed(1)} km",
                                  style: AppTextStyles.input.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Biaya Transport (PP)",
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.gold,
                              ),
                            ),
                            Text(
                              "Rp ${_estimasiBiaya!['biaya_transport'] ?? '-'}",
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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

          // Tombol Konfirmasi
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _estimasiBiaya != null
                      ? _lanjutKePembayaran
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _estimasiBiaya != null
                        ? AppColors.gold
                        : Colors.grey, // Solid Colors
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Konfirmasi Alamat",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
