import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Tambahkan offset agar mudah mengubah posisi profil dan nama
  final double profileTop; // posisi vertikal foto
  final double profileLeft; // posisi horizontal foto
  final double nameTop; // posisi vertikal nama

  const ProfileScreen({
    super.key,
    this.profileTop = 120, // default posisi
    this.profileLeft = 0,
    this.nameTop = 210,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas (header gradasi + foto profil)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background gradasi
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(140),
                        bottomRight: Radius.circular(140),
                      ),
                    ),
                  ),

                  // Foto profil (bisa diatur posisinya)
                  Positioned(
                    top: 165,
                    left:
                        MediaQuery.of(context).size.width / 2 -
                        50 +
                        profileLeft,
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile.jpeg'),
                    ),
                  ),

                  // Nama pengguna (bisa diatur posisinya)
                  Positioned(
                    top: 268,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: Text(
                        "Farel Sumandar",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE1D07E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 150),

              // Daftar menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      text: "Profil Saya",
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                    ProfileMenuItem(
                      icon: Icons.assignment_outlined,
                      text: "Rekam Medis",
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      text: "Ubah Kata Sandi",
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                    ProfileMenuItem(
                      icon: Icons.notifications_none,
                      text: "Notifikasi",
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      text: "Panduan",
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      text: "Keluar",
                      isLast: true,
                      textColor: const Color(0xFFE1D07E), // Warna emas
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFB300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Daftar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: "Gigi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

// Widget item menu
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;
  final Color textColor; // Tambahkan parameter warna teks
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.isLast = false,
    this.onTap,
    this.textColor = const Color(0xFFFFD700), // Default warna emas
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFFFFD700)),
          title: Text(
            text,
            style: TextStyle(
              color: textColor, // Gunakan warna yang bisa disesuaikan
              fontSize: 16,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
