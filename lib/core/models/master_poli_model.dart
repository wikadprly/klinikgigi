// lib/core/models/master_poli_model.dart

class MasterPoliModel {
  final String kodePoli;
  final String namaPoli;
  final String keterangan;

  MasterPoliModel({
    required this.kodePoli,
    required this.namaPoli,
    required this.keterangan,
  });

  factory MasterPoliModel.fromJson(Map<String, dynamic> json) {
    return MasterPoliModel(
      kodePoli: json['kode_poli']?.toString() ?? '',
      namaPoli: json['nama_poli']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_poli': kodePoli,
      'nama_poli': namaPoli,
      'keterangan': keterangan,
    };
  }
}
