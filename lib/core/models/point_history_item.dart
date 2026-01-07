// Model ini digunakan untuk memetakan data JSON (Riwayat Poin) dari API Laravel
// yang dikirim dari endpoint `/points/history`

class PointHistoryItem {
  final int id;
  final int userId;
  final int amount;
  final String transactionType; // Nilai dari Laravel: 'credit' atau 'debit'
  final String description;
  final DateTime createdAt;

  PointHistoryItem({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.createdAt,
  });

  // Factory constructor: Mengubah Map/JSON menjadi objek PointHistoryItem
  factory PointHistoryItem.fromJson(Map<String, dynamic> json) {
    return PointHistoryItem(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      amount: json['amount'] as int,
      transactionType: json['transaction_type'] as String,
      description: json['description'] as String,
      // Konversi string tanggal/waktu ISO 8601 ke objek DateTime
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
