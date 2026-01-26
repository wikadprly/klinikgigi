import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'package:flutter_klinik_gigi/core/storage/shared_prefs_helper.dart';
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
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profil = Provider.of<ProfilProvider>(context, listen: false);

      namaController.text = profil.user?['nama_pengguna'] ?? '';
      noHpController.text = profil.user?['no_hp'] ?? '';
      emailController.text = profil.user?['email'] ?? '';
      genderController.text = profil.user?['jenis_kelamin'] ?? '';
      // Extract just the date part (YYYY-MM-DD) from the string to avoid timezone issues
      String? rawDate = profil.user?['tanggal_lahir']?.toString();
      debugPrint('Raw date from API in two_page: $rawDate');

      String formattedDate = '';

      if (rawDate != null && rawDate.isNotEmpty) {
        // Handle different date formats that might come from the API
        if (rawDate.contains('T')) {
          formattedDate = rawDate.split('T')[0];
        } else if (rawDate.contains(' ')) {
          formattedDate = rawDate.split(' ')[0];
        } else {
          formattedDate = rawDate.substring(0, rawDate.length >= 10 ? 10 : rawDate.length);
        }
      }

      debugPrint('Formatted date for birthController: $formattedDate');
      birthController.text = formattedDate;
      alamatController.text = profil.user?['alamat'] ?? '';
    });
  }

  Future<void> saveData() async {
    if (!_validateForm()) return;

    final profil = Provider.of<ProfilProvider>(context, listen: false);
    final token = await SharedPrefsHelper.getToken();

    if (token == null) {
      _showError("Token tidak ditemukan, silakan login ulang");
      return;
    }

    try {
      setState(() => isSaving = true);

      debugPrint('About to save date: ${birthController.text.trim()}');

      final data = {
        'nama_pengguna': namaController.text.trim(),
        'no_hp': noHpController.text.trim(),
        'email': emailController.text.trim(),
        'jenis_kelamin': genderController.text.trim(),
        'tanggal_lahir': birthController.text.trim(),
        'alamat': alamatController.text.trim(),
      };

      debugPrint('Sending data to API: $data');

      final success = await profil.updateProfil(token, data);

      if (success && mounted) {
        _showSuccess('Informasi profil berhasil diperbarui');
        Navigator.pop(context);
      } else {
        _showError('Gagal menyimpan data');
      }
    } catch (e) {
      _showError('Terjadi error: $e');
    } finally {
      if (mounted) setState(() => isSaving = false);
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

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      _showError("Format email tidak valid");
      return false;
    }

    if (noHpController.text.trim().length < 10) {
      _showError("Nomor telepon harus minimal 10 digit");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54),
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
    DateTime initialDate = DateTime(2000);
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (e) {
      debugPrint('Error parsing initial date: $e');
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.gold,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (pickedDate != null) {
      debugPrint('Selected date from picker: $pickedDate');
      // Format tanggal sebagai YYYY-MM-DD tanpa timezone untuk API
      final formattedDate = "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      debugPrint('Formatted date for controller: $formattedDate');
      controller.text = formattedDate;
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
              Row(
                children: [
                  BackButtonWidget(onPressed: () => Navigator.pop(context)),
                  const Spacer(),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      color: AppColors.gold,
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
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

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

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
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
