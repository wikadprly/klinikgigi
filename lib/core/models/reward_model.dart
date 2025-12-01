// lib/core/models/reward_model.dart

import 'package:flutter/material.dart';

/// Model untuk merepresentasikan data satu item Point Reward
class RewardModel {
  final String id;
  final String title;
  final String description; 
  final int requiredPoints;
  final IconData icon; 

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredPoints,
    required this.icon,
  });

  /// Factory constructor untuk membuat instance RewardModel dari data JSON (Map)
  factory RewardModel.fromJson(Map<String, dynamic> json) {
    
    // --- Logika Mapping Icon ---
    // Mengkonversi string nama icon dari backend menjadi IconData Flutter
    IconData mapIcon(String iconName) {
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
      id: json['id'].toString(), // Pastikan ID selalu string
      title: json['title'] as String,
      description: json['description'] as String,
      requiredPoints: json['required_points'] as int,
      icon: mapIcon(json['icon_name'] as String), // Menggunakan fungsi mapping
    );
  }
}