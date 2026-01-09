import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_klinik_gigi/config/api.dart';
import '../storage/shared_prefs_helper.dart';
import '../models/reward_model.dart';

class RewardRepository {
  /// 1. MENGAMBIL DAFTAR PROMO
  Future<List<RewardModel>> fetchAllRewards() async {
    try {
      // Menggunakan endpoint dari api.dart
      final response = await http.get(Uri.parse(ApiEndpoint.homeCarePromos));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
        // Fallback jika endpoint promos gagal, coba endpoint /promo lama
        // (Jaga-jaga jika route di backend belum disesuaikan)
        final fallbackResponse = await http.get(Uri.parse('$baseUrl/promo'));
        if (fallbackResponse.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(fallbackResponse.body);
          final List<dynamic> data = body['data'];
          return data.map((json) => RewardModel.fromJson(json)).toList();
        }

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
      final user = await SharedPrefsHelper.getUser();
      if (user == null) return 0;

      // Menggunakan endpoint dari api.dart
      final response = await http.get(
        Uri.parse('${ApiEndpoint.homeCareUserPoints}?user_id=${user.userId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
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
      final user = await SharedPrefsHelper.getUser();
      if (user == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/redeem-promo'),
        body: {'user_id': user.userId, 'promo_id': promoId.toString()},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error Redeem: $e');
      return false;
    }
  }
}
