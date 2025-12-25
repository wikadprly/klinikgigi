import 'package:flutter/material.dart';
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
          const SnackBar(content: Text('Gagal memuat data dari server')),
        );
      }
    }
  }

  // --- Fungsi untuk Menangani Penukaran Poin ---
  Future<void> _handleRedeem(RewardModel reward) async {
    // Tampilkan konfirmasi dahulu
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text('Konfirmasi', style: AppTextStyles.heading.copyWith(color: AppColors.gold)),
        content: Text('Tukarkan ${reward.requiredPoints} poin untuk ${reward.title}?', style: TextStyle(color: AppColors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Tukar', style: TextStyle(color: AppColors.gold))),
        ],
      ),
    );

    if (confirm == true) {
      // Tampilkan Loading
      showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.gold)));
      
      try {
        bool success = await _repository.redeemReward(reward.id as int);
        Navigator.pop(context); // Tutup Loading

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil menukarkan ${reward.title}!')));
          _fetchData(); // Refresh data agar poin berkurang otomatis
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proses gagal. Silakan coba lagi.')));
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan koneksi.')));
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
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTotalPointCard(_userPoints),
                    const SizedBox(height: 24.0),
                    Text(
                      'Tukarkan Poin', 
                      style: AppTextStyles.input.copyWith(color: AppColors.gold),
                    ),
                    const SizedBox(height: 12.0),
                    _buildRewardList(_rewards, _userPoints), 
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildHistoryButton(context),
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
                    colorFilter: const ColorFilter.mode(AppColors.gold, BlendMode.srcIn),
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
                      style: const TextStyle(color: AppColors.white, fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Poin', 
                      style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
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

  Widget _buildRewardList(List<RewardModel> rewards, int userPoints) {
    if (rewards.isEmpty) {
      return Center(child: Text("Tidak ada promo tersedia", style: TextStyle(color: AppColors.textMuted)));
    }
    
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
          
          final Color buttonColor = isEnabled ? AppColors.gold : Colors.grey[700]!;
          final Color textColor = isEnabled ? AppColors.background : Colors.grey[500]!;
          final Color iconColor = isEnabled ? AppColors.gold : Colors.grey[500]!;

          return ListTile(
            leading: Icon(reward.icon, color: iconColor, size: 28),
            title: Text(
              reward.title, 
              style: AppTextStyles.input.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Butuh ${reward.requiredPoints} Poin', 
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
            ),
            trailing: ElevatedButton(
              onPressed: isEnabled ? () => _handleRedeem(reward) : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                minimumSize: const Size(80, 30),
              ),
              child: Text(
                'Tukar',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ), 
          ); 
        },
      ), 
    ); 
  } 

  Widget _buildHistoryButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, MediaQuery.of(context).padding.bottom + 16.0),
      decoration: BoxDecoration(
        color: AppColors.background, 
        border: Border(top: BorderSide(color: AppColors.cardDark, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text('Lihat dari mana poin anda berasal', style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
          Text('dalam Riwayat', style: AppTextStyles.label.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: () {
               // Navigasi ke History Screen di sini
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                  colors: [AppColors.gold, AppColors.gold.withOpacity(0.8)], 
                ),
              ),
              child: Text(
                'Lihat Riwayat',
                textAlign: TextAlign.center,
                style: AppTextStyles.button.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}