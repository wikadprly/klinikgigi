import 'package:flutter/material.dart';
import 'package:flutter_klinik_gigi/theme/colors.dart';
import 'package:flutter_klinik_gigi/theme/text_styles.dart';
import 'package:flutter_klinik_gigi/features/auth/widgets/auth_back.dart';
import 'package:provider/provider.dart';
import 'package:flutter_klinik_gigi/providers/profil_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

String _formatTanggalLahir(String? tanggalLahir) {
  if (tanggalLahir == null || tanggalLahir.isEmpty) return "-";

  try {
    // Parse string menjadi DateTime
    DateTime parsedDate = DateTime.parse(tanggalLahir.split('.')[0]);

    // Format menjadi DD-MM-YYYY
    String day = parsedDate.day.toString().padLeft(2, '0');
    String month = parsedDate.month.toString().padLeft(2, '0');
    String year = parsedDate.year.toString();

    return '$day-$month-$year';
  } catch (e) {
    // Jika parsing gagal, kembalikan nilai asli
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
        return jenisKelamin; // Jika tidak sesuai, kembalikan nilai asli
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
  // IMAGE PICKER METHODS
  // ==========================
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _selectFromGallery() async {
    try {
      print("Starting gallery selection...");

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        print("File selected: ${pickedFile.path}");

        // Normalize the file path to handle platform differences
        String filePath = pickedFile.path.replaceAll('\\', '/');

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          ),
        );

        try {
          final provider = Provider.of<ProfilProvider>(context, listen: false);
          bool success = await provider.updateProfilePicture(
            File(filePath),
          );

          Navigator.pop(context); // Close loading

          if (success) {
            _showSuccessMessage("Foto berhasil diunggah dari galeri");
            // Force UI refresh
            if (mounted) {
              setState(() {});
            }
          } else {
            _showErrorMessage(provider.errorMessage ?? "Gagal mengunggah foto");
          }
        } catch (e) {
          Navigator.pop(context);
          _showErrorMessage("Error saat mengunggah: $e");
          print("Error uploading image: $e");
        }
      } else {
        print("No file selected");
      }
    } catch (e) {
      _showErrorMessage("Gagal memilih foto dari galeri: $e");
      print("Error selecting image from gallery: $e");
    }
  }

  Future<void> _takePhoto() async {
    try {
      print("Starting camera...");

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        print("Photo taken: ${pickedFile.path}");

        // Normalize the file path to handle platform differences
        String filePath = pickedFile.path.replaceAll('\\', '/');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          ),
        );

        try {
          final provider = Provider.of<ProfilProvider>(context, listen: false);
          bool success = await provider.updateProfilePicture(
            File(filePath),
          );

          Navigator.pop(context);

          if (success) {
            _showSuccessMessage("Foto berhasil diambil");
            if (mounted) {
              setState(() {});
            }
          } else {
            _showErrorMessage(provider.errorMessage ?? "Gagal mengunggah foto");
          }
        } catch (e) {
          Navigator.pop(context);
          _showErrorMessage("Error saat mengunggah: $e");
          print("Error uploading image: $e");
        }
      }
    } catch (e) {
      _showErrorMessage("Gagal mengambil foto: $e");
      print("Error taking photo: $e");
    }
  }

  Future<void> _deletePhoto() async {
    try {
      // Show confirmation dialog
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
        // Update the provider to remove the profile picture
        final provider = Provider.of<ProfilProvider>(context, listen: false);
        bool success = await provider.removeProfilePicture();

        if (success) {
          // Show success message
          _showSuccessMessage("Foto berhasil dihapus");
        } else {
          _showErrorMessage(provider.errorMessage ?? "Gagal menghapus foto");
        }
      }
    } catch (e) {
      _showErrorMessage("Gagal menghapus foto");
      print("Error deleting photo: $e");
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

  // =======================================================================
  // POPUP EDIT FOTO
  // =======================================================================
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
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
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
                backgroundImage:
                    provider.userData?["file_foto"] != null &&
                        provider.userData?["file_foto"].isNotEmpty
                    ? NetworkImage(provider.userData?["file_foto"])
                    : const AssetImage('assets/images/profile.jpeg'),
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
                  Navigator.pop(
                    modalContext,
                  ); // Close the modal before opening gallery
                  _selectFromGallery();
                },
              ),
              const SizedBox(height: 14),
              _menuItem(
                icon: Icons.camera_alt,
                text: "Ambil foto",
                onTap: () {
                  Navigator.pop(
                    modalContext,
                  ); // Close the modal before opening camera
                  _takePhoto();
                },
              ),
              const SizedBox(height: 14),
              _menuItem(
                icon: Icons.delete,
                text: "Hapus",
                onTap: () {
                  Navigator.pop(
                    modalContext,
                  ); // Close the modal before deleting
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

  // =======================================================================
  // BUILD UI + API INTEGRATION
  // =======================================================================
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

            final user = provider.profilData;

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

                  // FOTO + NAMA API
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            provider.userData?["file_foto"] != null &&
                                provider.userData?["file_foto"].isNotEmpty
                            ? NetworkImage(provider.userData?["file_foto"])
                            : const AssetImage('assets/images/profile.jpeg'),
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
                          provider.rekamMedisData?["alamat"] ?? "-",
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

                  // CARD ASURANSI API
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
                        Text(
                          "Status : ${provider.statusAktif ?? "-"}",
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