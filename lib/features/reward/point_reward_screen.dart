import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/core/models/reward_model.dart';
import 'package:flutter_klinik_gigi/core/services/reward_repository.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';

class PointRewardScreen extends StatefulWidget {
  const PointRewardScreen({super.key});
  @override
  State<PointRewardScreen> createState() => _PointRewardScreenState();
}

class _PointRewardScreenState extends State<PointRewardScreen> {
  // Pastikan Anda telah memperbaiki path import di reward_repository.dart
  final RewardRepository _repository = RewardRepository();
  List<RewardModel> _rewards = [];
  int _userPoints = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedRewards = await _repository.fetchAllRewards();
      final fetchedPoints = await _repository.fetchUserPoints();

      setState(() {
        _rewards = fetchedRewards;
        _userPoints = fetchedPoints;
        _isLoading = false;
      });
    } catch (e) {
      // Peringatan 'avoid_print' bisa diabaikan untuk development
      print('Error fetching reward data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text(
          '3K Rewards',
          // Menggunakan AppTextStyles.heading
          style: AppTextStyles.heading.copyWith(color: AppColors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.gold))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTotalPointCard(_userPoints),
                  const SizedBox(height: 24.0),
                  Text(
                    'Tukarkan Poin',
                    // Menggunakan AppTextStyles.heading
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _buildRewardList(_rewards, _userPoints),
                  const SizedBox(height: 30.0),
                  _buildHistoryCard(),
                ],
              ),
            ),
    );
  }

  // --- Widget 1: Total Poin Anda ---
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
              // Menggunakan AppTextStyles.label
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                // Perbaikan withOpacity menjadi withAlpha
                CircleAvatar(
                  backgroundColor: AppColors.gold.withAlpha(
                    (255 * 0.1).round(),
                  ),
                  child: Icon(
                    Icons.monetization_on_outlined,
                    color: AppColors.gold,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      points.toString(),
                      // Menggunakan TextStyle eksplisit karena displayBold tidak ada
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Poin',
                      // Menggunakan AppTextStyles.label
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

  // --- Widget 2: Daftar Rewards ---
  Widget _buildRewardList(List<RewardModel> rewards, int userPoints) {
    return Card(
      color: AppColors.cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          final bool isEnabled = userPoints >= reward.requiredPoints;

          final Color buttonColor = isEnabled
              ? AppColors.gold
              : Colors.grey[700]!;
          final Color textColor = isEnabled
              ? AppColors.background
              : Colors.grey[500]!;
          final Color iconColor = isEnabled
              ? AppColors.gold
              : Colors.grey[500]!;

          return ListTile(
            leading: Icon(reward.icon, color: iconColor, size: 28),
            title: Text(
              reward.title,
              // Menggunakan AppTextStyles.input (paling mendekati body/normal text)
              style: AppTextStyles.input.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Butuh ${reward.requiredPoints} Poin',
              // Menggunakan AppTextStyles.label
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
            // ===============================================
            // PERBAIKAN SINTAKSIS ELEVATEDBUTTON
            // ===============================================
            trailing: ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      // TODO: Tambahkan logika penukaran poin (misalnya memanggil _repository.redeemReward)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Menukarkan ${reward.title} dengan ${reward.requiredPoints} Poin',
                          ),
                        ),
                      );
                      // Setelah penukaran, panggil _fetchData() untuk refresh poin
                      // _fetchData();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                minimumSize: const Size(80, 30),
              ), // Tombol disable jika isEnabled false

              child: Text(
                'Tukar',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ), // <<< PENUTUP ElevatedButton
          ); // <<< PENUTUP ListTile
        },
      ), // <<< PENUTUP ListView.builder
    ); // <<< PENUTUP Card
  } // <<< PENUTUP _buildRewardList

  // --- Widget 3: Riwayat Penukaran (Wajib ditambahkan) ---
  Widget _buildHistoryCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Penukaran',
          style: AppTextStyles.heading.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 12.0),
        // Implementasi sederhana
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            'Riwayat Anda muncul di sini',
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  } // <<< PENUTUP _buildHistoryCard
} // <<< PENUTUP _PointRewardScreenStateS
