// lib/models/pasien_model.dart

class Pasien {
  final int id;
  final String nama;
  final String jenisKelamin;
  final String foto;
  final String rekamMedis;
  final DateTime tanggalLahir;

  Pasien({
    required this.id,
    required this.nama,
    required this.jenisKelamin,
    required this.foto,
    required this.rekamMedis,
    required this.tanggalLahir,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    // Ambil string gender lengkap (Perempuan/Laki-laki) dari users
    String genderDb = json['jenis_kelamin'].toString().toLowerCase();

    return Pasien(
      id: int.parse(json['id'].toString()),
      nama: json['nama'] ?? '', // Mengambil Nama dari users
      // LOGIC BARU: Menerjemahkan String dari DB ("Perempuan" / "Laki-laki")
      jenisKelamin: (genderDb.contains('laki-laki')) ? 'Pria' : 'Wanita',
      foto: json['file_foto'] ?? 'default.png', // Mengambil foto dari users
      rekamMedis: json['no_identitas'] ?? '',
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
    );
  }

  int get umur {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }
}
