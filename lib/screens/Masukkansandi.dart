import 'package:flutter/material.dart';

class MasukKataSandiPage extends StatefulWidget {
  const MasukKataSandiPage({super.key});

  @override
  State<MasukKataSandiPage> createState() => _MasukKataSandiPageState();
}

class _MasukKataSandiPageState extends State<MasukKataSandiPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1B24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1B24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Kata Sandi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan Kata Sandi",
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Masukkan kata sandi lama untuk mengubah ke kata sandi baru",
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Input Password
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Masukkan kata sandi lama",
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tips Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE0C15A)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tips bikin Kata Sandi yang aman",
                    style: TextStyle(
                      color: Color(0xFFE0C15A),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("1. Hindari huruf/nomor berulang & berurutan, seperti 12345/abcde.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text("2. Jangan gunakan nama, tanggal lahir, atau nomor HP agar sulit ditebak.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text("3. Buat kata sandi unik & tidak pernah digunakan sebelumnya.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Lanjut
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aksi ketika klik tombol
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0C15A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Lanjut",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
