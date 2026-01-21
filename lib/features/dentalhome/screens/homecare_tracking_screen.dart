import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/features/dentalhome/screens/timeline_progres.dart';
import '../providers/home_care_provider.dart';

class HomeCareTrackingScreen extends StatefulWidget {
  final int bookingId;
  const HomeCareTrackingScreen({super.key, required this.bookingId});

  @override
  State<HomeCareTrackingScreen> createState() => _HomeCareTrackingScreenState();
}

class _HomeCareTrackingScreenState extends State<HomeCareTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Start polling via Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeCareProvider>(
        context,
        listen: false,
      ).startTrackingPolling(widget.bookingId);
    });
  }

  @override
  void dispose() {
    // Stop Polling when leaving screen
    // We need to use listen: false outside of build
    // But since dispose cannot depend on context for Provider unmounting sometimes,
    // it's checking if mounted usually.
    // However, for Provider, we can just call it.
    // NOTE: If context is invalid, this might throw. Safest is checking mounted?
    // Actually standard practice is just calling it.
    // Provider.of<HomeCareProvider>(context, listen: false).stopPolling();
    // But we can't context access in dispose easily if widget is unmounted from tree.
    // Actually we can, but let's just leave it to the Provider not to leak if we were implementing it strictly.
    // But here, we explicit stop.
    super.dispose();
  }

  // We actually need to stop polling.
  // The provider is higher up, so it WON'T be disposed when this screen pops.
  // So we MUST call stopPolling.
  @override
  void deactivate() {
    Provider.of<HomeCareProvider>(context, listen: false).stopPolling();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Darker background per design
      appBar: AppBar(
        title: const Text(
          "Lacak Kunjungan Anda",
          style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/main_screen',
            (route) => false,
          ),
        ),
      ),
      body: Consumer<HomeCareProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Info Card
                  _buildDoctorInfoCard(provider),

                  const SizedBox(height: 30),

                  // 2. Timeline
                  TimelineProgresModule(
                    currentStatus: provider.currentStatus,
                    doctorName: provider.doctorName,
                  ),

                  const SizedBox(height: 40),

                  // 3. Action Buttons
                  if (provider.isReadyForSettlement &&
                      provider.settlementStatus != 'lunas')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/dentalhome/pelunasan',
                            arguments: {
                              'bookingId': widget.bookingId,
                              'totalTagihan': provider.totalTagihan,
                            },
                          ).then((_) {
                            // Refresh on return
                            provider.fetchTrackingData(widget.bookingId);
                          });
                        },
                        child: const Text(
                          "Selesaikan Pembayaran",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main_screen',
                        (route) => false,
                      ),
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorInfoCard(HomeCareProvider provider) {
    // Format Date
    String formattedDate = provider.scheduleDate;
    try {
      if (provider.scheduleDate != '-') {
        final date = DateTime.parse(provider.scheduleDate);
        formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(date);
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No. Pemeriksaan : ${provider.noPemeriksaan}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            provider.doctorName,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Jadwal : $formattedDate, ${provider.scheduleTime}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          if (provider.queueNumber > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Urutan Kunjungan #${provider.queueNumber}",
                style: const TextStyle(
                  color: Colors.black, // Dark text on Gold
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
