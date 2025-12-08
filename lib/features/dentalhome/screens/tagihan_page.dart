import 'package:flutter/material.dart';
import 'nota_pelunasan.dart';

// Minimal compatibility widget: TagihanPage used by payment screens.
// It simply navigates to NotaPelunasanScreen by id parsed from noPemeriksaan when possible.
class TagihanPage extends StatelessWidget {
  final String? noPemeriksaan;

  const TagihanPage({super.key, this.noPemeriksaan});

  @override
  Widget build(BuildContext context) {
    // Try to parse an integer id from noPemeriksaan if possible
    int? id;
    if (noPemeriksaan != null) {
      final digits = RegExp(r"(\d+)").firstMatch(noPemeriksaan!);
      if (digits != null) {
        id = int.tryParse(digits.group(0)!);
      }
    }

    // If we have an id, show NotaPelunasanScreen with minimal transaction data,
    // else show placeholder. NotaPelunasanScreen expects a Map `transactionData`.
    if (id != null) {
      final Map<String, dynamic> transactionData = {
        'kode_booking': 'TRX-$id',
        'metode': 'Unknown',
        'nominal': 0,
        'waktu': DateTime.now(),
      };
      return NotaPelunasanScreen(transactionData: transactionData);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tagihan')),
      body: const Center(child: Text('Data tagihan tidak tersedia')),
    );
  }
}
