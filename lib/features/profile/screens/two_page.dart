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
  // CONTROLLER YANG BENAR (SATU FIELD = SATU CONTROLLER)
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final profil = Provider.of<ProfileProvider>(context, listen: false);

    // MAPPING DATA DARI PROVIDER
    namaController.text = profil.user?["nama_pengguna"] ?? "";
    noHpController.text = profil.user?["no_hp"] ?? "";
    emailController.text = profil.user?["email"] ?? "";
    birthController.text = profil.user?["tanggal_lahir"] ?? "";
    alamatController.text = profil.user?["alamat"] ?? "";
  }

  Future<void> saveData() async {
    final profil = Provider.of<ProfileProvider>(context, listen: false);

    setState(() => isSaving = true);

    final token = profil.user?["token"] ?? "";

    // DATA SESUAI BACKEND
    final data = {
      "nama_pengguna": namaController.text,
      "no_hp": noHpController.text,
      "email": emailController.text,
      "tanggal_lahir": birthController.text,
      "alamat": alamatController.text,
    };

    final success = await profil.updateProfil(token, data);

    setState(() => isSaving = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informasi profil berhasil diperbarui")),
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
                  readOnly: controller == birthController ? true : false,
                  onTap: () async {
                    if (controller == birthController) {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFBFA05A), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFBFA05A), // button text color
                                ),
                              ),
                            ),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                      );
                      if (pickedDate != null) {
                        String formattedDate = "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        setState(() {
                          controller.text = formattedDate;
                        });
                      }
                    }
                  },
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

              // HEADER
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

              const SizedBox(height: 40),

              const Text(
                "Informasi Dasar",
                style: TextStyle(
                  color: AppColors.goldDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              inputField(Icons.person, namaController, "Nama Lengkap"),
              const SizedBox(height: 12),

              inputField(Icons.phone, noHpController, "Nomor Telepon"),
              const SizedBox(height: 12),

              inputField(Icons.email, emailController, "Email"),
              const SizedBox(height: 12),

              inputField(Icons.calendar_today, birthController, "Tanggal Lahir"),
              const SizedBox(height: 12),

              inputField(Icons.home, alamatController, "Alamat"),

              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
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
            ],
          ),
        ),
      ),
    );
  }
}
