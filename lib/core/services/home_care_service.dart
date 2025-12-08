import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

// Pastikan import ini mengarah ke file api.dart yang Anda kirim
import '../../config/api.dart';
import '../models/home_care_booking.dart';
import '../models/validation_exception.dart';

/// Service helper to interact with the HomeCare API endpoints.
class HomeCareService {
  final Client client;
  final String? tokenOverride;

  HomeCareService({Client? client, this.tokenOverride})
    : client = client ?? http.Client();

  // ===========================================================================
  // 1. GET JADWAL DOKTER (FITUR BARU)
  // ===========================================================================
  Future<List<dynamic>> getJadwalDokter(String tanggal) async {
    final token = await _getToken();

    // Menggunakan endpoint dari api.dart + query parameter tanggal
    final url = Uri.parse(
      '${ApiEndpoint.homeCareJadwalMaster}?tanggal=$tanggal',
    );

    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);

    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Mengembalikan List jadwal dari key 'data'
      return data['data'];
    } else {
      throw Exception('Gagal memuat jadwal: ${response.body}');
    }
  }

  // ===========================================================================
  // 2. HITUNG ESTIMASI BIAYA
  // ===========================================================================
  Future<Map<String, dynamic>> calculateCost(double lat, double lng) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareCalculate);

    final requestBody = jsonEncode({'latitude': lat, 'longitude': lng});
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.post(
      url,
      headers: headers,
      body: requestBody,
    );

    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('data')) {
        return Map<String, dynamic>.from(responseBody['data']);
      }
    }

    throw Exception('Gagal menghitung biaya: ${response.body}');
  }

  // ===========================================================================
  // 3. CREATE BOOKING (UPDATED: RETURN MAP)
  // ===========================================================================
  // Return type diubah menjadi Map agar bisa membawa 'payment_info'
  Future<Map<String, dynamic>> createBooking({
    required int masterJadwalId,
    required String tanggal,
    required String keluhan,
    required double lat,
    required double lng,
    required String alamat,
    required String metodePembayaran,
  }) async {
    if (keluhan.trim().isEmpty) throw Exception('Keluhan tidak boleh kosong');
    if (alamat.trim().isEmpty) throw Exception('Alamat tidak boleh kosong');

    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareBook);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final requestBody = jsonEncode({
      'master_jadwal_id': masterJadwalId,
      'tanggal': tanggal,
      'keluhan': keluhan.trim(),
      'latitude_pasien': lat,
      'longitude_pasien': lng,
      'alamat_lengkap': alamat.trim(),
      'metode_pembayaran': metodePembayaran,
    });

    final response = await client.post(
      url,
      headers: headers,
      body: requestBody,
    );

    _checkHtmlError(response.body);
    _handleAuthError(response);
    _handleValidationError(response);

    // Success (Created)
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return {
          // Object Booking untuk diproses lebih lanjut jika perlu
          'booking': HomeCareBooking.fromJson(
            Map<String, dynamic>.from(data['data']),
          ),
          // Data Pembayaran (Expired Time, No VA, QR String) untuk UI Pembayaran
          'payment_info': data['payment_info'] ?? {},
        };
      }
    }

    throw Exception('Gagal booking: ${response.body}');
  }

  // ===========================================================================
  // 4. VALIDASI TOKEN
  // ===========================================================================
  Future<bool> validateToken() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) return false;

    final url = Uri.parse(ApiEndpoint.check);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final resp = await client.get(url, headers: headers);
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // 5. KONFIRMASI PEMBAYARAN (MANUAL)
  // ===========================================================================
  Future<bool> confirmPayment(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareConfirmPayment(bookingId));
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.post(url, headers: headers);
    _checkHtmlError(response.body);

    if (response.statusCode == 200) return true;

    throw Exception('Gagal konfirmasi pembayaran: ${response.body}');
  }

  // ===========================================================================
  // 6. TRACKING HISTORY
  // ===========================================================================
  Future<List<Map<String, dynamic>>> getTrackingHistory(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareTracking(bookingId));
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);
    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      final data = parsed['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e)),
        );
      }
    }

    throw Exception('Gagal mendapatkan tracking history');
  }

  // ===========================================================================
  // HELPERS (PRIVATE)
  // ===========================================================================

  Future<String?> _getToken() async {
    if (tokenOverride != null) return tokenOverride;
    return await SharedPrefsHelper.getToken();
  }

  void _checkHtmlError(String responseString) {
    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      throw Exception('Server error. Response contains HTML error page.');
    }
  }

  void _handleAuthError(Response response) {
    if (response.statusCode == 401) {
      throw Exception(
        'Unauthorized: Token tidak valid atau telah kadaluarsa. Silakan login kembali.',
      );
    }
  }

  void _handleValidationError(Response response) {
    if (response.statusCode == 400 || response.statusCode == 422) {
      try {
        final parsed = jsonDecode(response.body);
        final Map errorBody = parsed is Map ? parsed : {};
        // Laravel biasanya return 'errors' untuk validasi form
        final errorObj = errorBody['error'] ?? errorBody['errors'] ?? null;

        if (errorObj is Map) {
          final Map<String, List<String>> errors = {};
          errorObj.forEach((k, v) {
            if (v is List) {
              errors[k.toString()] = v.map((e) => e.toString()).toList();
            } else {
              errors[k.toString()] = [v.toString()];
            }
          });
          throw ValidationException(errors);
        } else if (errorObj is String) {
          throw Exception(errorObj);
        }
      } catch (e) {
        if (e is ValidationException) rethrow;
        // Jika parsing gagal, biarkan error generic di bawah yang menangkap
      }
    }
  }
}
