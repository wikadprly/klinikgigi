class Validator {
  // 🔹 Validasi Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null; // valid
  }

  // 🔹 Validasi Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // 🔹 Validasi Nomor HP
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP tidak boleh kosong';
    }
    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor HP harus berupa angka 10–13 digit';
    }
    return null;
  }

  // 🔹 Validasi NIK (Nomor Induk Kependudukan)
  static String? validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    final nikRegex = RegExp(r'^[0-9]{16}$');
    if (!nikRegex.hasMatch(value)) {
      return 'NIK harus 16 digit angka';
    }
    return null;
  }

  // 🔹 Validasi Nama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }
    return null;
  }

  // 🔹 Validasi Tanggal Lahir (opsional)
  static String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal lahir tidak boleh kosong';
    }
    // Kamu bisa tambahkan pengecekan format (dd/mm/yyyy) kalau mau
    return null;
  }
}