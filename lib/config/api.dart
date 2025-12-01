const String baseUrl = "http://127.0.0.1:8000/api"; // kalau pakai emulator

class ApiEndpoint {
  // AUTH
  static const login = "$baseUrl/login";
  static const register = "$baseUrl/register";
  static const logout = "$baseUrl/logout";
  static const check = "$baseUrl/check";

  // HOME CARE
  static const homeCareCalculate = "$baseUrl/homecare/calculate";
  static const homeCareBook = "$baseUrl/homecare/booking";
  static String homeCareConfirmPayment(int bookingId) =>
      "$baseUrl/homecare/booking/$bookingId/konfirmasi-bayar";
  static String homeCareTracking(int bookingId) =>
      "$baseUrl/homecare/booking/$bookingId/tracking";
  static const String pasien = "$baseUrl/pasien";
  static const String dokter = "$baseUrl/dokter";

  // 🔹 RESERVASI
  static const reservasiCreate = "$baseUrl/reservasi/create";
  static const reservasiGetPoli = "$baseUrl/reservasi/poli";
  static const reservasiGetDokter = "$baseUrl/reservasi/dokter";
  static const reservasiGetJadwal = "$baseUrl/reservasi/jadwal";
  static const reservasiRiwayat = "$baseUrl/reservasi/riwayat";
  static const reservasiPembayaran = "$baseUrl/reservasi/pembayaran";
  static String riwayat(String rekamMedisId) =>
      "$baseUrl/reservasi/riwayat/$rekamMedisId";

  static String updatePembayaran(String noPemeriksaan) =>
      "$baseUrl/reservasi/pembayaran/$noPemeriksaan";
}