import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/profil_provider.dart';

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

    // Isi nilai awal dari provider
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Informasi Tambahan"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Jenis Kelamin
            TextField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: "Jenis Kelamin",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Tanggal Lahir
            TextField(
              controller: birthController,
              decoration: const InputDecoration(
                labelText: "Tanggal Lahir",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Alamat
            TextField(
              controller: alamatController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Alamat",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveData,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
