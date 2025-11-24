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
    // Ambil field dengan fallback karena backend kadang mengembalikan nama
    // field yang berbeda (mis. `user_id` / `nama_pengguna` / `nik`).
    final dynamic rawId = json['id'] ?? json['user_id'] ?? json['pasien_id'];
    final String nama =
        (json['nama'] ?? json['nama_pengguna'] ?? json['name'] ?? '')
            .toString();
    final String jenisKelaminRaw =
        (json['jenis_kelamin'] ?? json['gender'] ?? '')
            .toString()
            .toLowerCase();
    final String foto = (json['file_foto'] ?? json['foto'] ?? 'default.png')
        .toString();
    final String rekamMedis =
        (json['rekam_medis_id'] ?? json['no_identitas'] ?? json['nik'] ?? '')
            .toString();

    // Parse id secara aman
    final int id = int.tryParse(rawId?.toString() ?? '') ?? 0;

    // Parse tanggal lahir secara aman; jika gagal gunakan epoch (1970) sebagai fallback
    DateTime tanggalLahir;
    final dynamic rawTanggal =
        json['tanggal_lahir'] ?? json['tanggalLahir'] ?? json['tgl_lahir'];
    if (rawTanggal == null) {
      tanggalLahir = DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      tanggalLahir =
          DateTime.tryParse(rawTanggal.toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    // Menerjemahkan variasi nilai gender ke tampilan aplikasi
    final String jenisKelamin = (jenisKelaminRaw.contains('laki'))
        ? 'Pria'
        : 'Wanita';

    return Pasien(
      id: id,
      nama: nama,
      jenisKelamin: jenisKelamin,
      foto: foto,
      rekamMedis: rekamMedis,
      tanggalLahir: tanggalLahir,
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
