import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// Sesuaikan path import ini dengan struktur folder Anda
import '../../core/storage/shared_prefs_helper.dart';
import '../../config/api.dart';
import '../models/home_care_booking.dart';
import '../models/validation_exception.dart';

class HomeCareService {
  final Client client;
  final String? tokenOverride;

  HomeCareService({Client? client, this.tokenOverride})
    : client = client ?? http.Client();

  // 1. GET JADWAL DOKTER
  Future<List<dynamic>> getJadwalDokter(
    String tanggal, {
    String? kodePoli,
  }) async {
    final token = await _getToken();

    String urlString = '${ApiEndpoint.homeCareJadwalMaster}?tanggal=$tanggal';
    if (kodePoli != null && kodePoli.isNotEmpty && kodePoli != 'Semua') {
      urlString += '&kode_poli=$kodePoli';
    }

    final url = Uri.parse(urlString);

    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);

    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal memuat jadwal: ${response.body}');
    }
  }

  // 2. HITUNG ESTIMASI BIAYA
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

  // 3. CREATE BOOKING (SINKRON DENGAN BACKEND BARU)
  Future<Map<String, dynamic>> createBooking({
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
      'rekam_medis_id': rekamMedisId,
      'master_jadwal_id': masterJadwalId,
      'tanggal': tanggal,

      'keluhan': keluhan.trim(),
      'jenis_keluhan': jenisKeluhan,
      'jenis_keluhan_lainnya': jenisKeluhanLainnya,
      'latitude_pasien': lat,
      'longitude_pasien': lng,
      'alamat_lengkap': alamat.trim(),
      'metode_pembayaran': metodePembayaran,
      'promo_id': promoId,
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
      final jsonResponse = jsonDecode(response.body);

      final reservationData = jsonResponse['data'];
      final paymentInfoData = jsonResponse['payment_info'];

      // Kembalikan Map berisi Objek Model Booking & Raw Payment Info
      return {
        'booking': HomeCareBooking.fromJson(reservationData),
        'payment_info': paymentInfoData ?? {}, // redirect_url ada di sini
      };
    }

    throw Exception('Gagal booking: ${response.body}');
  }

  // 4. CEK STATUS PEMBAYARAN (POLLING) - [DIPERBAIKI]
  Future<Map<String, dynamic>> checkPaymentStatus(int bookingId) async {
    final token = await _getToken();

    // PERBAIKAN: Menyusun URL secara manual karena tidak ada di ApiEndpoint
    // Menggunakan variabel 'baseUrl' yang diimport dari api.dart
    final urlString = '$baseUrl/homecare/booking/$bookingId/status';
    final url = Uri.parse(urlString);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(url, headers: headers);

    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Map<String, dynamic>.from(jsonResponse['data'] ?? {});
    }

    throw Exception('Gagal cek status pembayaran');
  }

  // 5. VALIDASI TOKEN
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

  // 6. TRACKING HISTORY
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

  // 7. GET USER POINTS
  Future<int> getUserPoints(String userId) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiEndpoint.homeCareUserPoints}?user_id=$userId');

    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);
    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['poin'] ?? 0;
    }
    return 0; // Return 0 if failed or no points
  }

  // 8. GET PROMOS
  Future<List<Map<String, dynamic>>> getPromos({
    String type = 'booking',
    String?
    userId, // Optional: pass user_id to filter promos by user's usage limit
  }) async {
    final token = await _getToken();

    // Build URL with user_id if provided
    String urlString = '${ApiEndpoint.homeCarePromos}?type=$type';
    if (userId != null && userId.isNotEmpty) {
      urlString += '&user_id=$userId';
    }
    final url = Uri.parse(urlString);

    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);
    _checkHtmlError(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final data = jsonResponse['data'];
      if (data is List) {
        return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e)),
        );
      }
    }
    return [];
  }

  // 9. CREATE SETTLEMENT (PELUNASAN)
  Future<Map<String, dynamic>> createSettlement(
    int bookingId, {
    int? promoId,
  }) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareSettlement);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final requestBody = jsonEncode({'id': bookingId, 'promo_id': promoId});

    final response = await client.post(
      url,
      headers: headers,
      body: requestBody,
    );

    _checkHtmlError(response.body);
    _handleAuthError(response);
    _handleValidationError(response); // Handle logic errors like "Already Paid"

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'] ?? {}; // Contains snap_token, etc.
    }

    throw Exception('Gagal membuat link pelunasan: ${response.body}');
  }

  // --- FITUR BARU: CEK BOOKING AKTIF ---
  Future<Map<String, dynamic>?> checkActiveBooking() async {
    final token = await _getToken();
    final urlString = '$baseUrl/homecare/booking/active';
    final uri = Uri.parse(urlString);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          return Map<String, dynamic>.from(jsonResponse['data']);
        }
      }
    } catch (e) {
      // print("Error checking active booking service: $e");
    }
    return null;
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
        final errorObj = errorBody['error'] ?? errorBody['errors'];

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
      }
    }
  }
}
