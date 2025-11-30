import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';

class EditProfilPage2 extends StatefulWidget {
  const EditProfilPage2({super.key});

  @override
  State<EditProfilPage2> createState() => _EditProfilPage2State();
}

class _EditProfilPage2State extends State<EditProfilPage2> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  bool isSaving = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final profil = Provider.of<ProfilProvider>(context, listen: false);

        // Pastikan data sudah di-load
        if (profil.profilData == null) {
          await profil.fetchProfilFromToken();
        }

        final user = profil.userData;

        print("📋 Loading profile data: ${profil.profilData}");

        setState(() {
          namaController.text = user?['nama_pengguna']?.toString() ?? "";
          noHpController.text = user?['no_hp']?.toString() ?? "";
          emailController.text = user?['email']?.toString() ?? "";

          // Format tanggal lahir
          final rawDate = user?['tanggal_lahir']?.toString() ?? "";
          if (rawDate.isNotEmpty) {
            if (rawDate.contains("T")) {
              birthController.text = rawDate.split("T")[0];
            } else {
              birthController.text = rawDate;
            }
          }

          alamatController.text = user?['alamat']?.toString() ?? "";
        });
      } catch (e) {
        print("❌ Error loading profile data: $e");
      }
    });
  }

  Future<void> saveData() async {
    // Validasi form
    if (!_validateForm()) return;

    setState(() => isSaving = true);

    try {
      final profil = Provider.of<ProfilProvider>(context, listen: false);

      // Ambil token
      String? token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        _showError("Token tidak ditemukan, silakan login kembali");
        return;
      }

      // Prepare data untuk API
      final data = {
        "nama_pengguna": namaController.text.trim(),
        "no_hp": noHpController.text.trim(),
        "email": emailController.text.trim(),
        "tanggal_lahir": birthController.text.isNotEmpty
            ? birthController.text
            : null,
        "alamat": alamatController.text.trim(),
      };

      print("📤 Sending update data: $data");

      final success = await profil.updateProfil(token, data);

      if (success) {
        _showSuccess("Informasi profil berhasil diperbarui");
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _showError(profil.errorMessage ?? "Gagal menyimpan data");
      }
    } catch (e) {
      _showError("Terjadi error: $e");
      print("❌ Save data error: $e");
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  bool _validateForm() {
    if (namaController.text.trim().isEmpty) {
      _showError("Nama lengkap tidak boleh kosong");
      return false;
    }

    if (noHpController.text.trim().isEmpty) {
      _showError("Nomor telepon tidak boleh kosong");
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _showError("Email tidak boleh kosong");
      return false;
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      _showError("Format email tidak valid");
      return false;
    }

    // Validasi nomor telepon (minimal 10 digit)
    if (noHpController.text.trim().length < 10) {
      _showError("Nomor telepon harus minimal 10 digit");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget inputField(
    IconData icon,
    TextEditingController controller,
    String hint, {
    bool isDateField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54),
                errorStyle: const TextStyle(color: Colors.red),
              ),
              keyboardType: keyboardType,
              readOnly: isDateField,
              onTap: isDateField ? () => _selectDate(controller) : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.goldDark,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
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
                  const SizedBox(width: 40), // Untuk balance spacing
                ],
              ),

              const SizedBox(height: 40),

              // FORM TITLE
              const Text(
                "Informasi Dasar",
                style: TextStyle(
                  color: AppColors.goldDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // FORM FIELDS
              Column(
                children: [
                  inputField(Icons.person, namaController, "Nama Lengkap"),
                  const SizedBox(height: 16),

                  inputField(
                    Icons.phone,
                    noHpController,
                    "Nomor Telepon",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  inputField(
                    Icons.email,
                    emailController,
                    "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  inputField(
                    Icons.calendar_today,
                    birthController,
                    "Tanggal Lahir",
                    isDateField: true,
                  ),
                  const SizedBox(height: 16),

                  inputField(Icons.home, alamatController, "Alamat"),
                ],
              ),

              const SizedBox(height: 40),

              // SAVE BUTTON
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
                      elevation: 2,
                    ),
                    onPressed: isSaving ? null : saveData,
                    child: isSaving
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Menyimpan...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            "Simpan Perubahan",
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

  @override
  void dispose() {
    namaController.dispose();
    noHpController.dispose();
    emailController.dispose();
    birthController.dispose();
    alamatController.dispose();
    super.dispose();
  }
}
