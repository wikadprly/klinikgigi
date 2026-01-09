import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_klinik_gigi/core/models/reward_model.dart';
import 'package:flutter_klinik_gigi/core/services/reward_repository.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PointRewardScreen extends StatefulWidget {
  const PointRewardScreen({super.key});

  @override
  State<PointRewardScreen> createState() => _PointRewardScreenState();
}

class _PointRewardScreenState extends State<PointRewardScreen> {
  final RewardRepository _repository = RewardRepository();
  List<RewardModel> _rewards = [];
  int _userPoints = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // --- Fungsi untuk Mengambil Data Dinamis dari Laravel ---
  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      // Mengambil poin dan daftar reward secara paralel
      final results = await Future.wait([
        _repository.fetchUserPoints(),
        _repository.fetchAllRewards(),
      ]);

      setState(() {
        _userPoints = results[0] as int;
        _rewards = results[1] as List<RewardModel>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          '3K Rewards',
          style: AppTextStyles.heading.copyWith(color: AppColors.gold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: AppColors.gold,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTotalPointCard(_userPoints),
                    const SizedBox(height: 24.0),
                    Text(
                      'Katalog Promo',
                      style: AppTextStyles.input.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Gunakan promo pilihanmu saat melakukan pembayaran.',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildRewardList(_rewards),
                  ],
                ),
              ),
      ),
      // History Button Removed
    );
  }

  Widget _buildTotalPointCard(int points) {
    return Card(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Poin Anda',
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.gold.withOpacity(0.1),
                  child: SvgPicture.asset(
                    'assets/icons/point.svg',
                    // ignore: deprecated_member_use
                    color: AppColors.gold,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      points.toString(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Poin',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardList(List<RewardModel> rewards) {
    if (rewards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            "Tidak ada promo tersedia",
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Gambar Banner (Jika ada)
              if (reward.imageUrl != null && reward.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Builder(
                    builder: (context) {
                      String imgUrl = reward.imageUrl!;
                      // Fix for Android Emulator: Replace localhost -> 10.0.2.2 if NOT on Web
                      if (!kIsWeb) {
                        if (imgUrl.contains('localhost')) {
                          imgUrl = imgUrl.replaceAll('localhost', '10.0.2.2');
                        } else if (imgUrl.contains('127.0.0.1')) {
                          imgUrl = imgUrl.replaceAll('127.0.0.1', '10.0.2.2');
                        }
                      }

                      return Image.network(
                        imgUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          color: AppColors.cardDark.withOpacity(0.5),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.local_offer,
                            color: AppColors.textMuted.withOpacity(0.5),
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // 2. Konten Teks
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Icon kecil jika tidak ada gambar, atau sebagai pelengkap
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(reward.icon, color: AppColors.gold, size: 24),
                    ),
                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.title,
                            style: AppTextStyles.input.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${reward.requiredPoints} Poin',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
