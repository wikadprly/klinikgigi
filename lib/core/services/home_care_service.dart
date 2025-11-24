import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
import '../../config/api.dart';

class HomeCareService {
  // 1. Hitung Estimasi Biaya
  Future<Map<String, dynamic>> calculateCost(double lat, double lng) async {
    print("DEBUG: Attempting to calculate cost for Lat: $lat, Lng: $lng");
    final token = await _getToken();
    print("DEBUG: Token retrieved: ${token != null ? 'Available' : 'NULL'}");

    // Sesuaikan endpoint dengan route di Laravel: /api/homecare/calculate
    final url = Uri.parse(ApiEndpoint.homeCareCalculate);
    print("DEBUG: Request URL: $url");

    final requestBody = jsonEncode({'latitude': lat, 'longitude': lng});
    print("DEBUG: Request body: $requestBody");

    final headers = {
      'Content-Type': 'application/json',
    };

    // Hanya tambahkan token jika tersedia
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );

    print("DEBUG: Response status: ${response.statusCode}");
    print("DEBUG: Response headers: ${response.headers}");

    // Cek jika respons adalah HTML (menunjukkan error page Laravel)
    final responseString = response.body;
    if (responseString.contains('<!DOCTYPE html>') ||
        responseString.contains('<html')) {
      int truncateAt = responseString.length < 500 ? responseString.length : 500;
      print("DEBUG: HTML Response body (truncated): ${responseString.substring(0, truncateAt)}...");
      throw Exception('Server error. Response contains HTML error page.');
    }

    if (response.statusCode == 200) {
      // Cek apakah response berupa JSON
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        print("DEBUG: Unexpected content type: $contentType");
        throw Exception('Server mengembalikan response tidak valid: $contentType');
      }

      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('data')) {
        print("DEBUG: Successfully got calculation data: ${responseBody['data']}");
        return responseBody['data'];
      } else {
        print("DEBUG: Response body missing 'data' key: ${response.body}");
        throw Exception('Format response tidak valid: ${response.body}');
      }
    } else {
      print("DEBUG: HTTP Error ${response.statusCode}: ${response.body}");
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // 2. Buat Booking Home Care
  Future<Map<String, dynamic>> createBooking({
    required int masterJadwalId,
    required String tanggal,
    required String keluhan,
    required double lat,
    required double lng,
    required String alamat,
    required String metodePembayaran,
  }) async {
    print("DEBUG: Attempting to create booking");

    // Validasi input sebelum kirim request
    if (keluhan.trim().isEmpty) {
      throw Exception("Keluhan tidak boleh kosong");
    }
    if (alamat.trim().isEmpty) {
      throw Exception("Alamat tidak boleh kosong");
    }

    final token = await _getToken();
    print("DEBUG: Token for booking: ${token != null ? 'Available' : 'NULL'}");

    final url = Uri.parse(ApiEndpoint.homeCareBook);
    print("DEBUG: Booking URL: $url");

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json', // Tambahkan Accept header penting untuk Sanctum
    };

    // Hanya tambahkan token jika tersedia
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print("DEBUG: Authorization header added");
    } else {
      print("DEBUG: No token, sending without authorization");
    }

    final requestBody = jsonEncode({
      'master_jadwal_id': masterJadwalId,
      'tanggal': tanggal,
      'keluhan': keluhan.trim(), // Pastikan tidak ada whitespace kosong
      'latitude_pasien': lat,
      'longitude_pasien': lng,
      'alamat_lengkap': alamat.trim(), // Sama untuk alamat
      'metode_pembayaran': metodePembayaran,
    });

    print("DEBUG: Request body: $requestBody");

    final response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );

    print("DEBUG: Booking response status: ${response.statusCode}");
    print("DEBUG: Response headers: ${response.headers}");
    int maxLen = response.body.length < 200 ? response.body.length : 200;
    print("DEBUG: Response body preview: ${response.body.substring(0, maxLen)}...");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseString = response.body;
      if (responseString.contains('<!DOCTYPE html>') ||
          responseString.contains('<html')) {
        print("DEBUG: Received HTML response instead of JSON");
        int maxLen2 = responseString.length < 300 ? responseString.length : 300;
        print("DEBUG: Full HTML response preview: ${responseString.substring(0, maxLen2)}...");
        throw Exception('Server booking error. Response contains HTML error page.');
      }

      final data = jsonDecode(responseString);
      if (data.containsKey('data')) {
        print("DEBUG: Booking successful, data: ${data['data']}");
        return data['data'];  // Return the created booking data
      } else {
        throw Exception('Format response booking tidak valid: $responseString');
      }
    } else {
      // Cek jika respons berisi HTML (menunjukkan error page Laravel)
      final responseString = response.body;
      print("DEBUG: Error response body: $responseString");

      if (responseString.contains('<!DOCTYPE html>') ||
          responseString.contains('<html')) {
        print("DEBUG: Received HTML error page from server");
        int maxLen3 = responseString.length < 500 ? responseString.length : 500;
        print("DEBUG: HTML Error Content: ${responseString.substring(0, maxLen3)}...");
        throw Exception('Server booking error. Response contains HTML error page.');
      }
      throw Exception('Gagal booking: ${response.body}');
    }
  }

  // 3. Konfirmasi Pembayaran
  Future<bool> confirmPayment(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareConfirmPayment(bookingId));

    final headers = {
      'Content-Type': 'application/json',
    };

    // Hanya tambahkan token jika tersedia
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Cek jika respons berisi HTML (menunjukkan error page Laravel)
      final responseString = response.body;
      if (responseString.contains('<!DOCTYPE html>') ||
          responseString.contains('<html')) {
        throw Exception('Server konfirmasi error. Response contains HTML error page.');
      }
      throw Exception('Gagal konfirmasi pembayaran: ${response.body}');
    }
  }

  // 4. Dapatkan riwayat tracking
  Future<List<Map<String, dynamic>>> getTrackingHistory(int bookingId) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareTracking(bookingId));

    final headers = {
      'Content-Type': 'application/json',
    };

    // Hanya tambahkan token jika tersedia
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      // Cek jika respons berisi HTML (menunjukkan error page Laravel)
      final responseString = response.body;
      if (responseString.contains('<!DOCTYPE html>') ||
          responseString.contains('<html')) {
        throw Exception('Server tracking error. Response contains HTML error page.');
      }
      throw Exception('Gagal mendapatkan tracking history: ${response.body}');
    }
  }

  Future<String?> _getToken() async {
    // Gunakan SharedPrefsHelper yang konsisten dengan Auth service
    return await SharedPrefsHelper.getToken();
  }
}
