import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promo_model.dart';
import '../../config/api.dart'; // Menggunakan file config utama
import '../../config/app_config.dart';

class PromoService {
  // Ambil URL dari ApiConfig
  final String _url = '$baseUrl/promo';

  Future<List<PromoModel>> fetchPromos() async {
    if (AppConfig.demoMode) {
      return [
        PromoModel(
          id: 1,
          judulPromo: 'Gratis Konsultasi Pertama',
          deskripsi: 'Khusus pasien baru yang booking lewat aplikasi.',
          gambarBanner: 'assets/images/promo.png',
        ),
        PromoModel(
          id: 2,
          judulPromo: 'Diskon 20% Scaling',
          deskripsi: 'Berlaku untuk semua pasien Dental Home Care.',
          gambarBanner: 'assets/images/promo.png',
        ),
        PromoModel(
          id: 3,
          judulPromo: 'Cashback Pelunasan',
          deskripsi: 'Pelunasan lebih awal dapat cashback poin reward.',
          gambarBanner: 'assets/images/promo.png',
        ),
      ];
    }

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          List<dynamic> listData = jsonResponse['data'];
          return listData.map((data) => PromoModel.fromJson(data)).toList();
        } else {
          throw Exception('Gagal memuat data promo: Format API tidak sesuai');
        }
      } else {
        throw Exception(
          'Gagal memuat data promo. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Tambahkan print untuk melihat error di konsol debug
      print('Error di PromoService: $e');
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}
