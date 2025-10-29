// lib/screens/start_screen.dart
import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1717), // warna gelap sesuai gambar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Headphone kanan atas
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.headphones_rounded,
                    color: Color(0xFFFFC947),
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ),

              // Logo + Text
              Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo_klinik.png', // ganti sesuai nama asset kamu
                    height: 120,
                  ),
                  const SizedBox(height: 24),

                  // Teks utama
                  const Text(
                    'Mulai',
                    style: TextStyle(
                      color: Color(0xFFFFC947),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Teks deskripsi
                  const Text(
                    'Mulai dengan Daftar atau Masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Tombol Masuk dan Daftar
              Column(
                children: [
                  AuthButton(
                    text: 'Masuk',
                    onPressed: () {
                      // TODO: Tambahkan navigasi ke halaman login
                      // Navigator.pushNamed(context, '/login');
                    },
                  ),
                  AuthButton(
                    text: 'Daftar',
                    onPressed: () {
                      // TODO: Tambahkan navigasi ke halaman register
                      // Navigator.pushNamed(context, '/register');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
