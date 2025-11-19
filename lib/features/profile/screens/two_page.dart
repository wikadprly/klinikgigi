import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:provider/provider.dart';
import '/providers/profil_provider.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';

class EditProfilPage2 extends StatefulWidget {
  const EditProfilPage2({super.key});

  @override
  State<EditProfilPage2> createState() => _EditProfilPage2State();
}

class _EditProfilPage2State extends State<EditProfilPage2> {
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final profil = Provider.of<ProfileProvider>(context, listen: false);

    genderController.text = profil.user?["jenis_kelamin"] ?? "";
    birthController.text = profil.user?["tanggal_lahir"] ?? "";
    alamatController.text = profil.user?["alamat"] ?? "";
  }

  Future<void> saveData() async {
    final profil = Provider.of<ProfileProvider>(context, listen: false);

    setState(() => isSaving = true);

    final token = profil.user?["token"] ?? "";

    final data = {
      "jenis_kelamin": genderController.text,
      "tanggal_lahir": birthController.text,
      "alamat": alamatController.text,
    };

    final success = await profil.updateProfil(token, data);

    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informasi tambahan berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  Widget inputField(IconData icon, TextEditingController controller, String hint) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2727),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldDark, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER — TIDAK DIPINDAH
              Row(
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      color: AppColors.goldDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              // FORM DIGESER KE BAWAH DIKIT
              const SizedBox(height: 40),

              // LABEL
              const Text(
                "Informasi Dasar",
                style: TextStyle(
                  color: AppColors.goldDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // INPUT FIELDS
              inputField(Icons.person, genderController, "Nama Lengkap"),
              const SizedBox(height: 12),

              inputField(Icons.phone, birthController, "Nomor Telepon"),
              const SizedBox(height: 12),

              inputField(Icons.email, birthController, "Email"),
              const SizedBox(height: 12),

              inputField(Icons.calendar_today, birthController, "Tanggal Lahir"),
              const SizedBox(height: 12),

              inputField(Icons.home, alamatController, "Alamat"),

              // BIAR FORM TIDAK MELEKAT KE TOMBOL
              const SizedBox(height: 60),

              // TOMBOL SIMPAN 
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: isSaving ? null : saveData,
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Simpan",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
