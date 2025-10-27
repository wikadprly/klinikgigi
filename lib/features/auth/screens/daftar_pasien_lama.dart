import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;
  String selectedRole = 'Pasien Baru';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol back di kiri atas
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              // Logo dan judul
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_klinik_kecil.png',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Daftar",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFD700),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Dropdown Pasien Baru
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFD700)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF0B0A0A),
                    value: selectedRole,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFFD700)),
                    isExpanded: true,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                    items: ['Pasien Baru', 'Pasien Lama']
                        .map(
                          (role) => DropdownMenuItem(
                            value: role,
                            child: Text(
                              role,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Form Fields
              _buildTextField("Nama Pengguna"),
              _buildTextField("NIK"),
              _buildTextField("Tanggal Lahir"),
              _buildTextField("Jenis Kelamin"),
              _buildTextField("No.HP/Email"),
              _buildTextField("Password", isPassword: true),
              _buildTextField("Konfirmasi Password", isPassword: true),

              const SizedBox(height: 12),

              // Checkbox persetujuan
              const Text(
                "Setuju Dengan Terms & Condition?",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (val) {
                      setState(() {
                        agree = val ?? false;
                      });
                    },
                    checkColor: Colors.black,
                    activeColor: const Color(0xFFFFD700),
                    side: const BorderSide(color: Color(0xFFFFD700)),
                  ),
                  const Text(
                    "Setuju dan lanjutkan",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Tombol Daftar & Lanjutkan
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFF5C542)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: agree
                      ? () {
                          Navigator.pushNamed(context, '/home');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Daftar & Lanjutkan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Teks bawah "Sudah punya akun? Masuk"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun? ",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      "Masuk",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField builder dengan font Inter
  Widget _buildTextField(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            color: Colors.white70,
            fontSize: 15,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFD700)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFFFD700), width: 1.5),
          ),
        ),
      ),
    );
  }
}
