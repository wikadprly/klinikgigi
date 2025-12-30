import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import '../providers/home_care_provider.dart';

class InputLokasiScreen extends StatefulWidget {
  const InputLokasiScreen({super.key});

  @override
  State<InputLokasiScreen> createState() => _InputLokasiScreenState();
}

class _InputLokasiScreenState extends State<InputLokasiScreen> {
  final TextEditingController _alamatController = TextEditingController();
  late MapController _mapController;

  // Local state for Map and Location
  LatLng? _centerLocation;
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;

  // Form Data (from Arguments)
  Map<String, dynamic> _bookingData = {};
  bool _isInitData = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Auto-fetch location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitData) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _bookingData = args;
      }
      _isInitData = false;
    }
  }

  // Permission & Location Logic
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack("Layanan lokasi tidak aktif. Mohon aktifkan GPS.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack("Izin lokasi ditolak.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack(
          "Izin lokasi ditolak permanen. Buka pengaturan untuk mengizinkan.",
        );
        return;
      }

      // Get Position
      // Using a timeout can prevent hanging
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _updateMapPosition(position.latitude, position.longitude);
      await _processLocation(position.latitude, position.longitude);
    } catch (e) {
      _showSnack("Gagal mengambil lokasi: $e");
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  void _updateMapPosition(double lat, double lng) {
    if (!mounted) return;
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _centerLocation = LatLng(lat, lng);
    });
    // Move map safely
    try {
      _mapController.move(LatLng(lat, lng), 16.0);
    } catch (_) {}
  }

  // Logic to reverse geocode and calculate cost
  Future<void> _processLocation(double lat, double lng) async {
    // 1. Reverse Geocoding
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String fullAddress =
            "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}"
                .trim();
        // Cleanup comma issues
        fullAddress = fullAddress.replaceAll(RegExp(r'^, |,$'), '').trim();
        if (fullAddress.isEmpty)
          fullAddress =
              "Lokasi (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})";

        _alamatController.text = fullAddress;
      }
    } catch (e) {
      _alamatController.text =
          "Lokasi (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})";
    }

    // 2. Calculate Cost via Provider
    if (mounted) {
      context.read<HomeCareProvider>().calculateCost(lat, lng).catchError((e) {
        _showSnack("Gagal menghitung biaya: $e");
      });
    }
  }

  void _onMapIdle() {
    // Optional: Trigger recalculation when map stops moving?
    // Currently button based is safer for API quotas, but user experience is better with button.
    // We keep the "Hitung Ulang" button as per original design for control.
    // If we want to support map drag to update location variable:
    final center = _mapController.camera.center;
    // Just update local coordinate variable, but don't API call yet
    if (mounted) {
      setState(() {
        _latitude = center.latitude;
        _longitude = center.longitude;
        _centerLocation = center;
      });
    }
  }

  void _recalculateFromMapCenter() {
    if (_latitude != null && _longitude != null) {
      _processLocation(_latitude!, _longitude!);
    }
  }

  void _lanjutKePembayaran() {
    final provider = context.read<HomeCareProvider>();
    final estimasi = provider.estimasiBiaya; // This is a getter we added

    if (_latitude == null || estimasi == null) {
      _showSnack("Mohon tentukan lokasi dan tunggu estimasi biaya muncul");
      return;
    }

    // Merge location and cost data into arguments
    final nextArgs = {
      ..._bookingData,
      'alamat': _alamatController.text,
      'latitude': _latitude!,
      'longitude': _longitude!,
      'rincianBiaya': estimasi,
    };

    Navigator.pushNamed(context, '/dentalhome/pembayaran', arguments: nextArgs);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Pin Lokasi di Peta", style: AppTextStyles.heading),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<HomeCareProvider>(
        builder: (context, provider, child) {
          final estimasiBiaya = provider.estimasiBiaya;
          // You could also add isLoadingCost in provider if you want granule control

          return Stack(
            children: [
              // Content
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

                    // MAP
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.inputBorder),
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
                                    const LatLng(
                                      -6.9175,
                                      107.6191,
                                    ), // Default Bandung/Indonesia
                                initialZoom: 15.0,
                                interactionOptions: const InteractionOptions(
                                  flags:
                                      InteractiveFlag.all &
                                      ~InteractiveFlag.rotate,
                                ),
                                onPositionChanged: (pos, hasGesture) {
                                  if (hasGesture) {
                                    _onMapIdle();
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                ),
                              ],
                            ),
                          ),
                          // Static Pin
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
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

                    // Button: Hitung Ulang
                    SizedBox(
                      height: 40,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: AppColors.gold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoadingLocation
                            ? null
                            : _recalculateFromMapCenter,
                        icon: const Icon(
                          Icons.calculate,
                          color: AppColors.gold,
                          size: 16,
                        ),
                        label: const Text(
                          "Hitung Ulang Estimasi",
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Button: GPS Local
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.gold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoadingLocation
                            ? null
                            : _getCurrentLocation,
                        icon: _isLoadingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.gold,
                                ),
                              )
                            : const Icon(
                                Icons.my_location,
                                color: AppColors.gold,
                                size: 18,
                              ),
                        label: Text(
                          _isLoadingLocation
                              ? "Mengambil Lokasi..."
                              : "Gunakan Lokasi Saya",
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Address Field
                    const Text(
                      "Alamat Lokasi",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _alamatController,
                      readOnly:
                          true, // User can't edit manually to enforce valid geocode
                      style: AppTextStyles.input,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.cardDark,
                        hintText: "Alamat akan otomatis terisi...",
                        hintStyle: const TextStyle(color: Colors.white30),
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.gold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Estimasi Card
                    if (estimasiBiaya != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.cardDark,
                              AppColors.cardWarmDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Jarak ke Klinik",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.straighten,
                                      color: Colors.white54,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${(estimasiBiaya['jarak_km'] ?? 0).toStringAsFixed(1)} km",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white24, height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Biaya Transport (PP)",
                                  style: TextStyle(color: AppColors.gold),
                                ),
                                Text(
                                  "Rp ${estimasiBiaya['biaya_transport'] ?? '-'}",
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
                ),
              ),

              // Bottom Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: estimasiBiaya != null
                            ? AppColors.gold
                            : Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: estimasiBiaya != null
                          ? _lanjutKePembayaran
                          : null,
                      child: Text(
                        "Konfirmasi Alamat",
                        style: TextStyle(
                          color: estimasiBiaya != null
                              ? Colors.black
                              : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
