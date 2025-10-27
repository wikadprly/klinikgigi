import 'package:flutter/material.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true; // ✅ langsung inisialisasi di sini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1B1B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Back + Judul
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE1D07E),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E1B1B),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Ubah Kata Sandi",
                        style: const TextStyle(
                          color: Color(0xFFE1D07E),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 50),

              const Text(
                "Konfirmasi Kata Sandi baru",
                style: TextStyle(
                  color: Color(0xFFE1D07E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Ini tahap terakhir, setelah itu selesai!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              // 🔐 Input Password + Toggle Mata
              TextField(
                controller: _passwordController,
                obscureText: _isObscure,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "Masukkan kata sandi baru",
                  hintStyle: const TextStyle(color: Color.fromARGB(133, 0, 0, 0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Lanjut
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDF9E),
                    foregroundColor: const Color(0xFF1E1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    final password = _passwordController.text;
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kata sandi tidak boleh kosong!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Kata sandi baru berhasil disimpan: $password'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Lanjut",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
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