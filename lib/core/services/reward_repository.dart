import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reward_model.dart';

class RewardRepository {
  // Gunakan 10.0.2.2 jika di Emulator, atau 127.0.0.1 jika di browser/Edge
  final String baseUrl = 'http://127.0.0.1:8000/api'; 
  
  // Berdasarkan database kamu, ini adalah user_id milik Farrel (yang punya 50 poin)
  final String userId = "PSN20251029661"; 

  /// 1. MENGAMBIL DAFTAR PROMO
  Future<List<RewardModel>> fetchAllRewards() async {
    try {
      // PERBAIKAN: Gunakan /promo (tanpa 's') sesuai screenshot browser yang berhasil
      final response = await http.get(Uri.parse('$baseUrl/promo'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        // Karena JSON kamu dibungkus dalam {"status":"success", "data": [...]}
        final List<dynamic> data = body['data'];

        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
        throw Exception('Server mengembalikan status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error Fetch Promo: $e');
      rethrow;
    }
  }

  /// 2. MENGAMBIL TOTAL POIN PENGGUNA
  Future<int> fetchUserPoints() async {
    try {
      // Mengikuti api.php kamu: /homecare/user-points
      final response = await http.get(
        Uri.parse('$baseUrl/homecare/user-points?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Pastikan mengambil key 'poin' dari JSON
        return data['poin'] ?? 0; 
      } else {
        print('Gagal ambil poin, status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error Fetch Poin: $e');
      return 0;
    }
  }

  /// 3. FUNGSI PENUKARAN
  Future<bool> redeemReward(int promoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/redeem-promo'),
        body: {
          'user_id': userId,
          'promo_id': promoId.toString(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error Redeem: $e');
      return false;
    }
  }
}