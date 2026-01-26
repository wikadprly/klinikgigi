import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_klinik_gigi/core/utils/file_shim.dart';
import 'package:flutter_klinik_gigi/core/utils/image_picker_helper.dart';

// =======================================================
// FORMAT TANGGAL
// =======================================================
String _formatTanggalLahir(String? tanggalLahir) {
  debugPrint('Raw tanggal_lahir from API: $tanggalLahir');

  if (tanggalLahir == null || tanggalLahir.isEmpty) return "-";

  try {
    DateTime parsedDate;

    // Handle different date formats that might come from the API
    if (tanggalLahir.contains('T')) {
      // If it's an ISO format with time (e.g., "2005-12-18T17:00:00.000000Z")
      // Simply extract the date part before 'T' to avoid timezone conversion issues
      String dateString = tanggalLahir.split('T')[0];
      debugPrint('Extracted date part: $dateString');

      List<String> dateComponents = dateString.split('-');
      if (dateComponents.length == 3) {
        int year = int.tryParse(dateComponents[0]) ?? 0;
        int month = int.tryParse(dateComponents[1]) ?? 0;
        int day = int.tryParse(dateComponents[2]) ?? 0;

        if (year != 0 && month != 0 && day != 0) {
          parsedDate = DateTime.utc(year, month, day);
        } else {
          return tanggalLahir; // Return original if parsing failed
        }
      } else {
        return tanggalLahir; // Return original if format is unexpected
      }
    } else if (tanggalLahir.contains(' ')) {
      // If it's a datetime format with space (e.g., "2025-01-31 00:00:00")
      String datePart = tanggalLahir.split(' ')[0];
      List<String> dateComponents = datePart.split('-');
      if (dateComponents.length == 3) {
        int year = int.tryParse(dateComponents[0]) ?? 0;
        int month = int.tryParse(dateComponents[1]) ?? 0;
        int day = int.tryParse(dateComponents[2]) ?? 0;

        if (year != 0 && month != 0 && day != 0) {
          parsedDate = DateTime.utc(year, month, day);
        } else {
          return tanggalLahir; // Return original if parsing failed
        }
      } else {
        return tanggalLahir; // Return original if format is unexpected
      }
    } else {
      // If it's just a date in YYYY-MM-DD format
      List<String> dateComponents = tanggalLahir.split('-');
      if (dateComponents.length == 3) {
        int year = int.tryParse(dateComponents[0]) ?? 0;
        int month = int.tryParse(dateComponents[1]) ?? 0;
        int day = int.tryParse(dateComponents[2]) ?? 0;

        if (year != 0 && month != 0 && day != 0) {
          parsedDate = DateTime.utc(year, month, day);
        } else {
          return tanggalLahir; // Return original if parsing failed
        }
      } else {
        return tanggalLahir; // Return original if format is unexpected
      }
    }

    debugPrint('Final parsed UTC date: $parsedDate');

    // Format as DD-MM-YYYY
    final formatted = '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
    debugPrint('Final formatted date: $formatted');

    return formatted;
  } catch (e) {
    debugPrint('Error formatting date: $e');
    return tanggalLahir;
  }
}

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // =======================================================
  // FIX FOTO (ANTI UNGU + ANTI CACHE)
  // =======================================================
  ImageProvider _buildProfileImage(ProfilProvider provider) {
    final url = provider.photoUrl;

    if (url == null || url.isEmpty) {
      return const AssetImage('assets/images/profil.jpeg');
    }

    return NetworkImage("$url?v=${DateTime.now().millisecondsSinceEpoch}");
  }

  String _convertJenisKelamin(String? jenisKelamin) {
    if (jenisKelamin == null || jenisKelamin.isEmpty) return "-";

    switch (jenisKelamin.toLowerCase()) {
      case 'l':
      case 'laki-laki':
        return 'Laki-laki';
      case 'p':
      case 'perempuan':
        return 'Perempuan';
      default:
        return jenisKelamin;
    }
  }

  // ==========================
  // ROW INFORMASI API
  // ==========================
  Widget infoRow(IconData icon, String text, {Color? textColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.input.copyWith(
              color: textColor ?? AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================
  // TOMBOL EDIT PROFIL
  // ==========================
  Widget editProfileButton({required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              "Edit Profil",
              style: AppTextStyles.button.copyWith(
                fontSize: 14,
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  // IMAGE PICKER
  // ==========================
  final ImagePicker _imagePicker = ImagePicker();

  // =======================================================
  // PATCH AMAN (ANTI ERROR WEB)
  // =======================================================
  Future<void> _pickAndUploadSafe(ImageSource source) async {
    try {
      final XFile? image = await ImagePickerHelper.pickImage(source);
      if (image == null) return;

      try {
        final file = createFileFromPath(image.path);
        final provider = Provider.of<ProfilProvider>(context, listen: false);
        bool success = await provider.updateProfilePicture(file);

        if (success) {
          _showSuccessMessage("Foto berhasil diperbarui");
          if (mounted) setState(() {});
        } else {
          _showErrorMessage(provider.errorMessage ?? "Gagal mengunggah foto");
        }
      } catch (e) {
        if (e is UnsupportedError &&
            e.message == "File tidak didukung di Web") {
          _showErrorMessage("Upload foto tidak didukung di Web");
        } else {
          _showErrorMessage("Gagal mengunggah foto: ${e.toString()}");
        }
      }
    } catch (e) {
      _showErrorMessage("Gagal memilih foto: ${e.toString()}");
    }
  }

  Future<void> _deletePhoto() async {
    try {
      bool confirm =
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Konfirmasi Hapus"),
                content: const Text(
                  "Apakah Anda yakin ingin menghapus foto profil?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Hapus"),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirm) {
        final provider = Provider.of<ProfilProvider>(context, listen: false);
        bool success = await provider.removeProfilePicture();

        if (success) {
          _showSuccessMessage("Foto berhasil dihapus");
          if (mounted) setState(() {});
        } else {
          _showErrorMessage(provider.errorMessage ?? "Gagal menghapus foto");
        }
      }
    } catch (e) {
      _showErrorMessage("Gagal menghapus foto");
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // =======================================================
  // POPUP EDIT FOTO
  // =======================================================
  void showEditPhotoModal(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.45;
    final provider = Provider.of<ProfilProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      builder: (modalContext) {
        return Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit foto profil",
                    style: TextStyle(
                      color: AppColors.goldDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.goldDark,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CircleAvatar(
                radius: 40,
                backgroundImage: _buildProfileImage(provider),
              ),
              const SizedBox(height: 16),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.goldDark,
              ),
              const SizedBox(height: 18),
              _menuItem(
                icon: Icons.photo,
                text: "Pilih dari galeri",
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickAndUploadSafe(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 14),
              _menuItem(
                icon: Icons.camera_alt,
                text: "Ambil foto",
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickAndUploadSafe(ImageSource.camera);
                },
              ),
              const SizedBox(height: 14),
              _menuItem(
                icon: Icons.delete,
                text: "Hapus",
                onTap: () {
                  Navigator.pop(modalContext);
                  _deletePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldDark, size: 45),
          const SizedBox(width: 30),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.goldDark,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =======================================================
  // BUILD UI
  // =======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<ProfilProvider>(
            context,
            listen: false,
          ).fetchProfil(widget.token),
          builder: (context, snapshot) {
            final provider = Provider.of<ProfilProvider>(context);

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // HEADER
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BackButtonWidget(
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Profil Saya',
                          style: AppTextStyles.heading.copyWith(
                            color: AppColors.goldDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // FOTO + NAMA
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _buildProfileImage(provider),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.userData?["nama_pengguna"] ?? "-",
                        style: AppTextStyles.heading.copyWith(
                          color: AppColors.goldDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => showEditPhotoModal(context),
                        child: Text(
                          "Edit foto",
                          style: AppTextStyles.input.copyWith(
                            color: AppColors.goldDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // CARD INFO DASAR
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Informasi Dasar",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.gold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 14),
                        infoRow(
                          Icons.phone,
                          provider.userData?["no_hp"] ?? "-",
                          textColor: AppColors.goldDark,
                        ),
                        const SizedBox(height: 14),
                        infoRow(
                          Icons.email,
                          provider.userData?["email"] ?? "-",
                          textColor: AppColors.goldDark,
                        ),
                        const SizedBox(height: 14),
                        infoRow(
                          Icons.calendar_today,
                          _formatTanggalLahir(
                            provider.userData?["tanggal_lahir"],
                          ),
                          textColor: AppColors.goldDark,
                        ),
                        const SizedBox(height: 14),
                        infoRow(
                          Icons.location_on,
                          provider.userData?["alamat"] ?? "-",
                          textColor: AppColors.goldDark,
                        ),
                        const SizedBox(height: 14),
                        infoRow(
                          Icons.man,
                          _convertJenisKelamin(
                            provider.userData?["jenis_kelamin"],
                          ),
                          textColor: AppColors.goldDark,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: editProfileButton(
                            onTap: () =>
                                Navigator.pushNamed(context, "/two_page"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // CARD ASURANSI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.gold, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Asuransi Saya",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.gold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Nama Asuransi : ${provider.namaAsuransi ?? "-"}",
                          style: AppTextStyles.input.copyWith(
                            color: AppColors.goldDark,
                          ),
                        ),
                        Text(
                          "Nomor Peserta : ${provider.noPeserta ?? "-"}",
                          style: AppTextStyles.input.copyWith(
                            color: AppColors.goldDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
