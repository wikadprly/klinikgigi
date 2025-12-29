import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/services/home_care_service.dart';

class HomeCareProvider extends ChangeNotifier {
  final HomeCareService _service = HomeCareService();

  // ===========================================================================
  // STATE: GENERAL
  // ===========================================================================
  int _userPoints = 0;
  List<Map<String, dynamic>> _promos = [];
  bool _isLoadingPromos = false;

  // ===========================================================================
  // STATE: JADWAL & DOCTORS
  // ===========================================================================
  List<dynamic> _availableDoctors = [];
  bool _isLoadingDoctors = false;

  // Filter Categories (Dinamycally populated)
  List<String> _filterCategories = ['Semua'];
  final Map<String, String> _categoryToKodePoli = {'Semua': 'Semua'};

  // ===========================================================================
  // STATE: TRACKING & POLLING
  // ===========================================================================
  Timer? _timerPolling;
  bool _isPolling = false;

  // Tracking Data
  String _currentStatus = 'pending';
  String? _paymentStatus;
  String? _settlementStatus;
  int _totalTagihan = 0;
  String _doctorName = '-';
  String _scheduleDate = '-';
  String _scheduleTime = '-';

  // ===========================================================================
  // GETTERS
  // ===========================================================================
  int get userPoints => _userPoints;
  List<Map<String, dynamic>> get promos => _promos;
  bool get isLoadingPromos => _isLoadingPromos;

  List<dynamic> get availableDoctors => _availableDoctors;
  bool get isLoadingDoctors => _isLoadingDoctors;
  List<String> get filterCategories => _filterCategories;

  // Tracking Getters
  bool get isPolling => _isPolling;
  String get currentStatus => _currentStatus;
  String? get paymentStatus => _paymentStatus;
  String? get settlementStatus => _settlementStatus;
  int get totalTagihan => _totalTagihan;
  String get doctorName => _doctorName;
  String get scheduleDate => _scheduleDate;
  String get scheduleTime => _scheduleTime;

  bool get isReadyForSettlement {
    return _currentStatus == 'menunggu_pelunasan' ||
        _currentStatus == 'selesai_diperiksa';
  }

  // ===========================================================================
  // ACTIONS: POINTS & PROMOS
  // ===========================================================================
  Future<void> fetchUserPoints(String userId) async {
    try {
      final points = await _service.getUserPoints(userId);
      _userPoints = points;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching points: $e");
    }
  }

  Future<void> fetchPromos({String type = 'booking'}) async {
    _isLoadingPromos = true;
    notifyListeners();
    try {
      final data = await _service.getPromos(type: type);
      _promos = data;
    } catch (e) {
      debugPrint("Error fetching promos: $e");
    } finally {
      _isLoadingPromos = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // ACTIONS: JADWAL KUNJUNGAN
  // ===========================================================================
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDoctors(
    DateTime date, {
    String filterCategory = 'Semua',
  }) async {
    _isLoadingDoctors = true;
    _errorMessage = null; // Reset error
    // Notify only if we want to show loading immediately
    // If it flickers too much, we might want to delay notify
    notifyListeners();

    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      debugPrint(
        "HomeCareProvider: Fetching doctors for $formattedDate with filter $filterCategory",
      );

      String? kodePoli = _categoryToKodePoli[filterCategory];
      if (kodePoli == 'Semua')
        kodePoli = null; // Ensure null is passed if 'Semua'

      final data = await _service.getJadwalDokter(
        formattedDate,
        kodePoli: kodePoli,
      );

      debugPrint("HomeCareProvider: Fetched ${data.length} doctors");
      _availableDoctors = data;

      // Update Filter Categories only if we are viewing 'Semua'
      if (filterCategory == 'Semua') {
        _updateFilterCategories(data);
      }
    } catch (e) {
      debugPrint("HomeCareProvider Error fetching doctors: $e");
      _availableDoctors = [];
      _errorMessage = e
          .toString()
          .replaceAll("Exception:", "")
          .trim(); // Capture clean message
    } finally {
      _isLoadingDoctors = false;
      notifyListeners();
    }
  }

  void _updateFilterCategories(List<dynamic> data) {
    _categoryToKodePoli.clear();
    _categoryToKodePoli['Semua'] = 'Semua';
    final Set<String> categories = {'Semua'};

    for (var item in data) {
      final jadwal = item['master_jadwal'];
      final dokter = jadwal?['dokter'];
      final poli = jadwal?['poli'];

      String labelUI = '-';
      if (dokter != null && dokter['spesialis'] != null) {
        labelUI = dokter['spesialis']['nama_spesialis'] ?? '-';
      } else if (poli != null) {
        labelUI = poli['nama_poli'] ?? '-';
      } else {
        labelUI = dokter?['spesialisasi'] ?? '-';
      }

      final String kodePoli = jadwal?['kode_poli'] ?? '';

      if (labelUI != '-' && kodePoli.isNotEmpty) {
        categories.add(labelUI);
        _categoryToKodePoli[labelUI] = kodePoli;
      }
    }
    _filterCategories = categories.toList();
  }

  // ===========================================================================
  // ACTIONS: BOOKING
  // ===========================================================================
  Future<Map<String, dynamic>> submitBooking({
    required int rekamMedisId,
    required int masterJadwalId,
    required String tanggal,
    required String keluhan,
    String? jenisKeluhan,
    String? jenisKeluhanLainnya,
    required double lat,
    required double lng,
    required String alamat,
    required String metodePembayaran,
    int? promoId,
  }) async {
    try {
      final result = await _service.createBooking(
        rekamMedisId: rekamMedisId,
        masterJadwalId: masterJadwalId,
        tanggal: tanggal,
        keluhan: keluhan,
        jenisKeluhan: jenisKeluhan,
        jenisKeluhanLainnya: jenisKeluhanLainnya,
        lat: lat,
        lng: lng,
        alamat: alamat,
        metodePembayaran: metodePembayaran,
        promoId: promoId,
      );
      return {'success': true, 'data': result};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ===========================================================================
  // ACTIONS: LOCATION & COST
  // ===========================================================================
  Map<String, dynamic>? _estimasiBiaya;
  Map<String, dynamic>? get estimasiBiaya => _estimasiBiaya;

  Future<void> calculateCost(double lat, double lng) async {
    _estimasiBiaya = null; // Reset previous calculation
    notifyListeners();
    try {
      final result = await _service.calculateCost(lat, lng);
      _estimasiBiaya = result;
    } catch (e) {
      debugPrint("Error calculating cost: $e");
      rethrow; // Re-throw to handle in UI (Show Snackbar)
    } finally {
      notifyListeners();
    }
  }

  // ===========================================================================
  // ACTIONS: TRACING & POLLING
  // ===========================================================================

  // Polling for Booking Payment Confirmation (Initial Booking)
  void startBookingPaymentPolling(int bookingId, {required Function onPaid}) {
    if (_isPolling) return;
    _isPolling = true;
    notifyListeners();

    _timerPolling = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final statusData = await _service.checkPaymentStatus(bookingId);
        final statusPembayaran = statusData['status_pembayaran'];

        // Update local state if needed, but for booking polling mainly we check for succeess
        if (statusPembayaran == 'lunas' ||
            statusPembayaran == 'settlement' ||
            statusPembayaran == 'success') {
          stopPolling();
          onPaid();
        }
      } catch (e) {
        debugPrint("Booking Polling error: $e");
      }
    });
  }

  // Polling for General Status Tracking
  void startTrackingPolling(int bookingId) {
    // Prevent double polling
    stopPolling();

    // Fetch immediately
    fetchTrackingData(bookingId);

    _isPolling = true;
    // Faster polling for tracking
    _timerPolling = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchTrackingData(bookingId, silent: true);
    });
  }

  Future<void> fetchTrackingData(int bookingId, {bool silent = false}) async {
    if (!silent) {
      // Only show loading on full refresh/initial load
      // But typically for tracking page we might want a localized loader
      // For now let's just use notify to update UI
    }

    try {
      final statusData = await _service.checkPaymentStatus(bookingId);

      _currentStatus = statusData['status_reservasi'] ?? _currentStatus;
      _paymentStatus = statusData['status_pembayaran'];
      _settlementStatus = statusData['status_pelunasan'] ?? 'belum_lunas';
      _totalTagihan =
          int.tryParse(statusData['total_biaya_tindakan'].toString()) ?? 0;
      _doctorName = statusData['nama_dokter'] ?? '-';
      _scheduleDate = statusData['jadwal_tanggal'] ?? '-';
      _scheduleTime = statusData['jadwal_jam'] ?? '-';

      notifyListeners();
    } catch (e) {
      debugPrint("Tracking error: $e");
    }
  }

  void stopPolling() {
    _timerPolling?.cancel();
    _timerPolling = null;
    _isPolling = false;
    // notifyListeners(); // Optional
  }

  // Status Helper for UI
  int getStatusLevel() {
    final status = _currentStatus;

    // 1: Assigned / Initial State (Menunggu Dokter)
    if ([
      'menunggu',
      'menunggu_pembayaran',
      'Menunggu Pembayaran',
      'menunggu_dokter',
      'terverifikasi',
      'menunggu_konfirmasi',
      'Menunggu Konfirmasi',
    ].contains(status)) {
      return 1;
    }
    // 2: OTW
    if (['otw_lokasi', 'dokter_menuju_lokasi'].contains(status)) return 2;
    // 3: In Progress
    if (['sedang_diperiksa', 'dalam_pemeriksaan'].contains(status)) return 3;
    // 4: Billing / Done
    if ([
      'selesai_diperiksa',
      'menunggu_pelunasan',
      'menunggu_pembayaran_obat',
    ].contains(status)) {
      return 4;
    }
    // 5: Lunas
    if (['lunas'].contains(status)) return 5;

    return 0; // Default pending
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
