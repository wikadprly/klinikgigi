import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import '../../config/api.dart';
import '../models/home_care_booking.dart';
import '../models/validation_exception.dart';

/// Service helper to interact with the HomeCare API endpoints.
class HomeCareService {
  final Client client;
  final String? tokenOverride;

  HomeCareService({Client? client, this.tokenOverride})
    : client = client ?? http.Client();

  // 1. Hitung Estimasi Biaya
  Future<Map<String, dynamic>> calculateCost(double lat, double lng) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareCalculate);

    final requestBody = jsonEncode({'latitude': lat, 'longitude': lng});
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty)
      headers['Authorization'] = 'Bearer $token';

    final response = await client.post(
      url,
      headers: headers,
      body: requestBody,
    );

    final responseString = response.body;
    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      throw Exception('Server error. Response contains HTML error page.');
    }

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        throw Exception(
          'Server mengembalikan response tidak valid: $contentType',
        );
      }

      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('data'))
        return Map<String, dynamic>.from(responseBody['data']);
      throw Exception('Format response tidak valid: ${response.body}');
    }

    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }

  // 2. Buat Booking Home Care (typed)
  Future<HomeCareBooking> createBooking({
    required int masterJadwalId,
    required String tanggal,
    required String keluhan,
    required double lat,
    required double lng,
    required String alamat,
    required String metodePembayaran,
  }) async {
    // basic input validation
    if (keluhan.trim().isEmpty) throw Exception('Keluhan tidak boleh kosong');
    if (alamat.trim().isEmpty) throw Exception('Alamat tidak boleh kosong');

    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareBook);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty)
      headers['Authorization'] = 'Bearer $token';

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
    final responseString = response.body;

    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      throw Exception(
        'Server booking error. Response contains HTML error page.',
      );
    }

    // success
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(responseString);
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return HomeCareBooking.fromJson(
          Map<String, dynamic>.from(data['data']),
        );
      }
      throw Exception('Format response booking tidak valid: $responseString');
    }

    // authentication
    if (response.statusCode == 401) {
      throw Exception(
        'Unauthorized: Token tidak valid atau telah kadaluarsa. Silakan login kembali.',
      );
    }

    // validation errors (Laravel often returns 400 with 'error' or 422 with 'errors')
    if (response.statusCode == 400 || response.statusCode == 422) {
      try {
        final parsed = jsonDecode(responseString);
        final Map errorBody = parsed is Map ? parsed : {};
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
        }
      } catch (e) {
        // fallthrough to generic error
      }
    }

    // Try parse validation-like error regardless of status code before throwing generic error
    try {
      final parsed = jsonDecode(responseString);
      final Map errorBody = parsed is Map ? parsed : {};
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
      }
    } catch (e) {
      // ignore parsing errors and fall through to generic
    }

    // fallback
    throw Exception('Gagal booking: $responseString');
  }

  /// Helper: Validate token using the /check endpoint (returns true when token still valid)
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

  // 3. Konfirmasi Pembayaran
  Future<bool> confirmPayment(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareConfirmPayment(bookingId));
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty)
      headers['Authorization'] = 'Bearer $token';

    final response = await client.post(url, headers: headers);

    final responseString = response.body;
    if (response.statusCode == 200) return true;

    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      throw Exception(
        'Server konfirmasi error. Response contains HTML error page.',
      );
    }

    throw Exception('Gagal konfirmasi pembayaran: $responseString');
  }

  // 4. Dapatkan riwayat tracking
  Future<List<Map<String, dynamic>>> getTrackingHistory(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareTracking(bookingId));
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty)
      headers['Authorization'] = 'Bearer $token';

    final response = await client.get(url, headers: headers);
    final responseString = response.body;

    if (response.statusCode == 200) {
      final parsed = jsonDecode(responseString);
      final data = parsed['data'];
      if (data is List)
        return List<Map<String, dynamic>>.from(
          data.map((e) => Map<String, dynamic>.from(e)),
        );
      throw Exception('Format tracking response tidak valid');
    }

    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      throw Exception(
        'Server tracking error. Response contains HTML error page.',
      );
    }

    throw Exception('Gagal mendapatkan tracking history: $responseString');
  }

  Future<String?> _getToken() async {
    if (tokenOverride != null) return tokenOverride;
    return await SharedPrefsHelper.getToken();
  }
}
