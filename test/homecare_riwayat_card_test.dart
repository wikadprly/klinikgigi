import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_klinik_gigi/features/riwayat/widgets/homecare_riwayat_card.dart';

void main() {
  testWidgets('HomeCareRiwayatCard displays fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeCareRiwayatCard(
            noPemeriksaan: 'RM001',
            dokter: 'Dr. Test',
            jamMulai: '08:00',
            jamSelesai: '09:00',
            pembayaranTotal: '150000',
            metodePembayaran: 'Tunai',
            statusReservasi: 'selesai',
            data: {},
          ),
        ),
      ),
    );

    expect(find.text('No. Pemeriksaan : '), findsOneWidget);
    expect(find.text('RM001'), findsOneWidget);
    expect(find.text('Dr. Test'), findsOneWidget);
    expect(find.text('08:00 - 09:00'), findsOneWidget);
    expect(find.text('Rp.150000'), findsOneWidget);
    expect(find.text('Tunai'), findsOneWidget);
  });
}
