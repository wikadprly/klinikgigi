// lib/core/models/reward_model.dart

import 'package:flutter/material.dart';

/// Model untuk merepresentasikan data satu item Point Reward
class RewardModel {
  final String id;
  final String title;
  final String description;
  final int requiredPoints;
  final String? imageUrl;
  final IconData icon;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredPoints,
    this.imageUrl,
    required this.icon,
  });

  /// Factory constructor untuk membuat instance RewardModel dari data JSON (Map)
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    // --- Logika Mapping Icon ---
    // Mengkonversi string nama icon dari backend menjadi IconData Flutter
    // Backend tidak mengirim 'icon_name', jadi kita mapping manual atau default
    IconData mapIcon(String? iconName) {
      if (iconName == null) return Icons.local_offer; // Default icon
      switch (iconName.toLowerCase()) {
        case 'add_circle':
          return Icons.add_circle_outline;
        case 'diamond':
          return Icons.diamond_outlined;
        case 'flash':
          return Icons.flash_on;
        default:
          return Icons.star_outline;
      }
    }
    // ---------------------------

    return RewardModel(
      id: json['id'].toString(),
      title: (json['judul_promo'] ?? 'Promo Tanpa Judul').toString(),
      description: (json['deskripsi'] ?? '').toString(),
      requiredPoints: int.tryParse(json['harga_poin'].toString()) ?? 0,
      imageUrl: json['gambar_banner'] as String?,
      icon: mapIcon(null), // Backend belum kirim icon, pakai default
    );
  }
}
