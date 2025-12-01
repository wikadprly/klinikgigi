class MasterSpesialisModel {
  final int id;
  final String? nama;

  MasterSpesialisModel({required this.id, this.nama});

  factory MasterSpesialisModel.fromJson(Map<String, dynamic> json) {
    return MasterSpesialisModel(id: json['id'] as int, nama: json['nama']);
  }
}
