// lib/core/models/user_model.dart
class UserModel {
  final int userId;
  final String namaPengguna;
  final String nik;
  final int? rekamMedisId;
  final String tanggalLahir;
  final String jenisKelamin;
  final String noHp;
  final String email;
  final String password;
  final String? createdAt;
  final String? updatedAt;

  // Constructor
  UserModel({
    required this.userId,
    required this.namaPengguna,
    required this.nik,
    this.rekamMedisId,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.noHp,
    required this.email,
    required this.password,
    this.createdAt,
    this.updatedAt,
  });

  // Parsing dari JSON (data API Laravel)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] is String
          ? int.tryParse(json['user_id']) ?? 0
          : json['user_id'] ?? 0,
      namaPengguna: json['nama_pengguna'] ?? '',
      nik: json['nik'] ?? '',
      rekamMedisId: json['rekam_medis_id'] == null
          ? null
          : (json['rekam_medis_id'] is String
                ? int.tryParse(json['rekam_medis_id'])
                : json['rekam_medis_id']),
      tanggalLahir: json['tanggal_lahir'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      noHp: json['no_hp'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Mengubah ke JSON (untuk dikirim ke server)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama_pengguna': namaPengguna,
      'nik': nik,
      'rekam_medis_id': rekamMedisId,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
      'no_hp': noHp,
      'email': email,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
