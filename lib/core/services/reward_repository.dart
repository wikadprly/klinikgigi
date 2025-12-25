import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reward_model.dart';

class RewardRepository {
  // --- KONFIGURASI ENDPOINT ---
  // Gunakan 10.0.2.2 jika menggunakan Emulator Android. 
  // Gunakan localhost jika menggunakan browser/Edge.
  final String baseUrl = 'http://127.0.0.1:8000/api'; 
  
  // ID User yang sedang login (Ganti "1" sesuai data di tabel users kamu)
  final String userId = "1"; 

  /// 1. MENGAMBIL DAFTAR PROMO/REWARD DARI LARAVEL
  /// Menghubungkan ke PromoController@index
  Future<List<RewardModel>> fetchAllRewards() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/promos'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        // Mengonversi data JSON Laravel ke List RewardModel
        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar reward dari server');
      }
    } catch (e) {
      print('Error pada fetchAllRewards: $e');
      rethrow;
    }
  }

  /// 2. MENGAMBIL TOTAL POIN PENGGUNA DARI LARAVEL
  /// Menghubungkan ke PointController@getUserPoints
  Future<int> fetchUserPoints() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-user-points?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Pastikan cast ke int karena poin di DB biasanya integer
        return data['poin'] as int; 
      } else {
        return 0;
      }
    } catch (e) {
      print('Error pada fetchUserPoints: $e');
      return 0;
    }
  }

  /// 3. FUNGSI PROSES PENUKARAN (REDEEM)
  /// Menghubungkan ke API redeem-promo di Laravel
  Future<bool> redeemReward(int promoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/redeem-promo'),
        body: {
          'user_id': userId,
          'promo_id': promoId.toString(),
        },
      );

      // Return true jika status code 200 (OK)
      return response.statusCode == 200;
    } catch (e) {
      print('Error pada redeemReward: $e');
      return false;
    }
  }
}
