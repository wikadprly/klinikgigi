import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // opsional: latar belakang biar kontras
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ganti Icon dengan Gambar Asset
              Image.asset(
                'assets/images/Logo_klinik.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 100),

              const Text(
                "Mulai",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Mulai dengan Daftar atau Masuk",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Tombol Masuk
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Masuk",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Daftar
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register_new'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
