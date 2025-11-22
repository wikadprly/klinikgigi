import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/api.dart';

class HomeCareService {
  // 1. Hitung Estimasi Biaya
  Future<Map<String, dynamic>> calculateCost(double lat, double lng) async {
    final token = await _getToken();

    // Sesuaikan endpoint dengan route di Laravel: /api/homecare/calculate
    final url = Uri.parse(ApiEndpoint.homeCareCalculate);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'latitude': lat, 'longitude': lng}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Gagal menghitung biaya: ${response.body}');
    }
  }

  // 2. Buat Booking Home Care
  Future<bool> createBooking({
    required int masterJadwalId,
    required String tanggal,
    required String keluhan,
    required double lat,
    required double lng,
    required String alamat,
    required String metodePembayaran,
  }) async {
    final token = await _getToken();
    final url = Uri.parse(ApiEndpoint.homeCareBook);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'master_jadwal_id': masterJadwalId,
        'tanggal': tanggal,
        'keluhan': keluhan,
        'latitude_pasien': lat,
        'longitude_pasien': lng,
        'alamat_lengkap': alamat,
        'metode_pembayaran': metodePembayaran,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal booking: ${response.body}');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Sesuaikan key token Anda
  }
}
