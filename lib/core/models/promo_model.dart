class PromoModel {
  final int id;
  final String judulPromo;
  final String deskripsi;
  final String? gambarBanner; // Bisa null

  PromoModel({
    required this.id,
    required this.judulPromo,
    required this.deskripsi,
    this.gambarBanner,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] ?? 0,
      judulPromo: json['judul_promo'] ?? 'Tanpa Judul',
      deskripsi: json['deskripsi'] ?? '',
      gambarBanner: json['gambar_banner'],
    );
  }
}
