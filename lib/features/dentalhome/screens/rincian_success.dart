import 'package:flutter/material.dart';


class PaymentSuccessScreen extends StatelessWidget {
const PaymentSuccessScreen({super.key});


@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
children: [
const SizedBox(height: 20),
Hero(tag: 'success-icon', child: Icon(Icons.check_circle, size: 120, color: Colors.amber)),
const SizedBox(height: 12),
const Text('Pembayaran Berhasil', style: TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
const Text('Pembayaran telah berhasil, berikut nota pembayaran anda', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
const Spacer(),
ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Kembali', style: TextStyle(color: Colors.black))),
const SizedBox(height: 20),
],
),
),
),
);
}
}