import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Import Provider & Helpers
import '../../../../theme/colors.dart';
import '../../../core/storage/shared_prefs_helper.dart';
import '../providers/home_care_provider.dart';

class MidtransHomeCareBookingScreen extends StatefulWidget {
  final int masterJadwalId;
  final String tanggal;
  final String namaDokter;
  final String jamPraktek;
  final String keluhan;
  final String? jenisKeluhan;
  final String? jenisKeluhanLainnya;
  final String alamat;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> rincianBiaya;

  const MidtransHomeCareBookingScreen({
    super.key,
    required this.masterJadwalId,
    required this.tanggal,
    required this.namaDokter,
    required this.jamPraktek,
    required this.keluhan,
    this.jenisKeluhan,
    this.jenisKeluhanLainnya,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.rincianBiaya,
  });

  @override
  State<MidtransHomeCareBookingScreen> createState() =>
      _MidtransHomeCareBookingScreenState();
}

class _MidtransHomeCareBookingScreenState
    extends State<MidtransHomeCareBookingScreen> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  Map<String, dynamic>? _selectedPromo;
  int? _currentBookingId;
  int _lastPaidTotal = 0; // Store the amount paid for success screen

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = Provider.of<HomeCareProvider>(context, listen: false);
    final user = await SharedPrefsHelper.getUser();
    if (user != null) {
      // 1. Fetch Points
      provider.fetchUserPoints(user.userId);
      // 2. Fetch Promos
      provider.fetchPromos(type: 'booking', userId: user.userId);
    }
  }

  // --- CREATE BOOKING ---
  Future<void> _prosesPembayaranMidtrans() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );

    try {
      final user = await SharedPrefsHelper.getUser();
      if (user == null) {
        if (mounted) Navigator.pop(context);
        _showSnackbar('Sesi habis. Silakan login ulang.', isError: true);
        return;
      }

      if (user.rekamMedisId == null) {
        if (mounted) Navigator.pop(context);
        _showSnackbar(
          'Data pasien tidak lengkap. Silakan perbarui profil.',
          isError: true,
        );
        return;
      }

      if (!mounted) return;

      final provider = Provider.of<HomeCareProvider>(context, listen: false);

      final result = await provider.submitBooking(
        rekamMedisId: user.rekamMedisId!,
        masterJadwalId: widget.masterJadwalId,
        tanggal: widget.tanggal,
        keluhan:
            "${widget.jenisKeluhan}${widget.jenisKeluhanLainnya != null ? ': ${widget.jenisKeluhanLainnya}' : ''}",
        jenisKeluhan: widget.jenisKeluhan,
        jenisKeluhanLainnya: widget.jenisKeluhanLainnya,
        lat: widget.latitude,
        lng: widget.longitude,
        alamat: widget.alamat,
        metodePembayaran: 'midtrans',
        promoId: _selectedPromo?['id'],
      );

      if (mounted) Navigator.pop(context);

      if (result['success'] == true) {
        final data = result['data'];
        final bookingObj = data['booking'];
        final paymentInfo = data['payment_info'];

        if (bookingObj != null && paymentInfo != null) {
          final bookingId = bookingObj.id;
          final redirectUrl = paymentInfo['redirect_url'];
          final noPemeriksaan = bookingObj.noPemeriksaan;

          _currentBookingId = bookingId;

          if (redirectUrl != null && redirectUrl.isNotEmpty) {
            _launchPayment(redirectUrl, noPemeriksaan);
          } else {
            _showSnackbar('Gagal mendapatkan link pembayaran.', isError: true);
          }
        }
      } else {
        _showSnackbar(result['message'] ?? 'Terjadi kesalahan.', isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackbar('Terjadi kesalahan: ${e.toString()}', isError: true);
    }
  }

  Future<void> _launchPayment(String urlString, String noPemeriksaan) async {
    if (_currentBookingId != null) {
      final provider = Provider.of<HomeCareProvider>(context, listen: false);
      provider.startBookingPaymentPolling(
        _currentBookingId!,
        onPaid: () {
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(
                  bookingId: _currentBookingId,
                  totalBayar: _lastPaidTotal,
                ),
              ),
            );
          }
        },
      );
    }

    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) _showWaitingPaymentDialog();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka halaman pembayaran'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showWaitingPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: const Text(
            "Menunggu Pembayaran",
            style: TextStyle(color: AppColors.gold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Silakan selesaikan pembayaran di browser.\nAplikasi akan otomatis mendeteksi jika berhasil.",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                color: AppColors.gold,
                backgroundColor: Colors.white10,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Tutup",
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCareProvider>(
      builder: (context, provider, child) {
        final biaya = widget.rincianBiaya;
        final total = (biaya['estimasi_total'] as num?)?.toInt() ?? 0;
        final biayaLayanan = (biaya['biaya_layanan'] as num?)?.toInt() ?? 0;
        final biayaTransport = (biaya['biaya_transport'] as num?)?.toInt() ?? 0;

        // --- CALCULATE DISCOUNT ---
        int discount = 0;
        if (_selectedPromo != null) {
          final tipe = _selectedPromo!['tipe'];
          final val =
              int.tryParse(_selectedPromo!['nilai_potongan'].toString()) ?? 0;

          if (tipe == 'free_transport') {
            discount = biayaTransport;
          } else {
            // NEW LOGIC: Cap discount to Service Fee
            discount = (val > biayaLayanan) ? biayaLayanan : val;
          }
        }

        int finalTotal = total - discount;
        if (finalTotal < 0) finalTotal = 0;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("Konfirmasi & Pembayaran"),
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Pendaftaran",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailCard(),
                const SizedBox(height: 24),

                // --- PROMO SECTION ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Promo & Diskon",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (provider.isLoadingPromos)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.gold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPromoSelector(provider),

                const SizedBox(height: 24),
                const Text(
                  "Rincian Biaya",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBiayaCard(finalTotal, discount, provider),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.cardDark,
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _lastPaidTotal = finalTotal;
                    _prosesPembayaranMidtrans();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Lanjut Pembayaran (${currencyFormatter.format(finalTotal)})",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromoSelector(HomeCareProvider provider) {
    bool hasPromo = _selectedPromo != null;
    return GestureDetector(
      onTap: () => _showPromoModal(provider),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasPromo ? AppColors.gold : Colors.white12,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.discount_outlined,
              color: hasPromo ? AppColors.gold : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasPromo
                        ? (_selectedPromo?['judul_promo'] ?? 'Promo Terpilih')
                        : "Gunakan Kode Promo / Poin",
                    style: TextStyle(
                      color: hasPromo ? Colors.white : AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasPromo)
                    Text(
                      "Hemat ${currencyFormatter.format(int.tryParse(_selectedPromo!['nilai_potongan'].toString()) ?? 0)}",
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (hasPromo)
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPromo = null;
                  });
                },
              )
            else
              const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showPromoModal(HomeCareProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            final promos = provider.promos;
            return Column(
              children: [
                // Handle bar
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pilih Promo Tersedia",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.gold,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${provider.userPoints} Poin",
                              style: const TextStyle(
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
                const SizedBox(height: 16),
                // List
                Expanded(
                  child: promos.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada promo tersedia saat ini",
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: promos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final promo = promos[index];
                            final pointsCost =
                                int.tryParse(promo['harga_poin'].toString()) ??
                                0;
                            final isAffordable =
                                provider.userPoints >= pointsCost;
                            final isAvailable =
                                promo['is_available'] == true; // Backend flag

                            bool canRedeem = isAffordable && isAvailable;

                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardDark,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedPromo?['id'] == promo['id']
                                      ? AppColors.gold
                                      : Colors.white10,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(8),
                                    image: promo['gambar_banner'] != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              promo['gambar_banner'],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: promo['gambar_banner'] == null
                                      ? const Icon(
                                          Icons.local_offer,
                                          color: AppColors.gold,
                                        )
                                      : null,
                                ),
                                title: Text(
                                  promo['judul_promo'] ?? 'Promo',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      promo['deskripsi'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                          color: canRedeem
                                              ? AppColors.gold
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "$pointsCost Poin",
                                          style: TextStyle(
                                            color: canRedeem
                                                ? AppColors.gold
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: canRedeem
                                      ? () {
                                          setState(() {
                                            _selectedPromo = promo;
                                          });
                                          Navigator.pop(context);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.gold,
                                    disabledBackgroundColor: Colors.white10,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(60, 30),
                                  ),
                                  child: Text(
                                    canRedeem
                                        ? "Pakai"
                                        : (isAvailable
                                              ? "Kurang Poin"
                                              : "Habis"),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _rowDetail("Dokter", widget.namaDokter),
          _rowDetail("Jadwal", "${widget.tanggal} • ${widget.jamPraktek}"),
          if (widget.jenisKeluhan != null)
            _rowDetail("Jenis Keluhan", widget.jenisKeluhan!),
          if (widget.jenisKeluhan == 'Lainnya' &&
              widget.jenisKeluhanLainnya != null)
            _rowDetail("Detail Keluhan", widget.jenisKeluhanLainnya!),
          _rowDetail("Lokasi", widget.alamat, isMultiline: true),
        ],
      ),
    );
  }

  Widget _buildBiayaCard(
    int finalTotal,
    int discount,
    HomeCareProvider provider,
  ) {
    final biaya = widget.rincianBiaya;
    final layanan = biaya['biaya_layanan'] ?? 0;
    final transport = biaya['biaya_transport'] ?? 0;
    final jarak = biaya['jarak_km'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          _rowBiaya("Biaya Layanan", layanan),
          _rowBiaya("Biaya Transport ($jarak km)", transport),
          if (discount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Diskon Promo",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    "- ${currencyFormatter.format(discount)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                currencyFormatter.format(finalTotal),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rowDetail(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          const Text(": ", style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              maxLines: isMultiline ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowBiaya(String label, dynamic value) {
    final num val = (value is num) ? value : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(
            currencyFormatter.format(val),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final int? bookingId;
  final int totalBayar;
  const PaymentSuccessScreen({super.key, this.bookingId, this.totalBayar = 0});

  int get earnedPoints => (totalBayar / 10000).floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.gold,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Transaksi Berhasil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Pembayaran telah kami terima",
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "No. Booking",
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                          Text(
                            "#${bookingId ?? '-'}",
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            child: Text(
                              "LUNAS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (earnedPoints > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Poin Didapat",
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.gold,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "+$earnedPoints Poin",
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (bookingId != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/dentalhome/tracking',
                          arguments: bookingId,
                        );
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Lihat Status Pemeriksaan",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
