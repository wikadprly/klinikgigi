import 'package:flutter/material.dart';

void main() {
  runApp(const UbahKataSandiApp());
}

class UbahKataSandiApp extends StatelessWidget {
  const UbahKataSandiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UbahKataSandiPage(),
    );
  }
}

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1B1B), // Warna background gelap
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Header: Icon panah + teks judul di tengah
          Row(
            children: [
              // Tombol panah kiri
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFE1D07E)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Ubah Kata Sandi',
                    style: const TextStyle(
                      color: Color(0xFFE1D07E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Spacer agar teks benar-benar di tengah
              const SizedBox(width: 48), // lebar iconButton agar simetris
            ],
          ),

              const SizedBox(height: 20),

              // Subjudul
              const Text(
                'Buat Kata Sandi baru',
                style: TextStyle(
                  color: Color(0xFFE1D07E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih Kata Sandi yang unik dan jangan dibagikan ke siapa pun',
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13),
              ),

              const SizedBox(height: 20),

              // Input Kata Sandi
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Masukkan kata sandi baru',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tips
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE1D07E), width: 0.8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tips bikin Kata Sandi yang aman',
                      style: TextStyle(
                        color: Color(0xFFE1D07E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Hindari huruf/nomor berulang & berurut, contoh 123456/aaaa.\n'
                      '2. Jangan menggunakan nama, tanggal lahir, atau nomor HP.\n'
                      '3. Buat Kata Sandi yang unik.',
                      style: TextStyle(color: Color(0xFFE1D07E), fontSize: 13),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol Lanjut
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi jika tombol ditekan
                    final password = _passwordController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kata sandi baru: $password')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1D07E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Lanjut',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}