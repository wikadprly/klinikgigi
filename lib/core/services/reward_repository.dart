// lib/services/reward_repository.dart

import '../models/reward_model.dart';
// import 'api.dart'; // Di sini Anda akan mengimpor API service Anda

class RewardRepository {
  final int _userCurrentPoints = 1520; // Data statis untuk simulasi

  /// Mendapatkan daftar semua reward yang tersedia dari API (simulasi)
  Future<List<RewardModel>> fetchAllRewards() async {
    // Diimplementasi nyata, ganti ini dengan panggilan _apiService.get('rewards')
    await Future.delayed(const Duration(milliseconds: 500)); 

    final List<Map<String, dynamic>> rawData = [
      {'id': 1, 'title': 'Potongan 10% Scaling gigi', 'description': 'Potongan 10% Scaling gigi', 'required_points': 500, 'icon_name': 'add_circle'},
      {'id': 2, 'title': 'Voucher Bleaching Rp 30.000', 'description': 'Voucher Bleaching Rp 30.000', 'required_points': 700, 'icon_name': 'diamond'},
      {'id': 3, 'title': 'Sikat Gigi Elektrik Gratis', 'description': 'Sikat Gigi Elektrik Gratis', 'required_points': 2000, 'icon_name': 'flash'},
    ];

    return rawData.map((json) => RewardModel.fromJson(json)).toList();
  }

  /// Mendapatkan total poin pengguna saat ini (simulasi)
  Future<int> fetchUserPoints() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _userCurrentPoints;
  }
}