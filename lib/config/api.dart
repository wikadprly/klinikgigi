const String baseUrl = "http://127.0.0.1:8000/api"; // Laragon Virtual Host

class ApiEndpoint {
  // AUTH
  static const login = "$baseUrl/login";
  static const register = "$baseUrl/register";
  static const logout = "$baseUrl/logout";
  static const check = "$baseUrl/check";

  // HOME CARE
  static const String homeCareJadwalMaster = "$baseUrl/homecare/jadwal";
  static const homeCareCalculate = "$baseUrl/homecare/calculate";
  static const homeCareBook = "$baseUrl/homecare/booking";
  static String homeCareConfirmPayment(int bookingId) =>
      "$baseUrl/homecare/booking/$bookingId/konfirmasi-bayar";
  static String homeCareTracking(int bookingId) =>
      "$baseUrl/homecare/booking/$bookingId/tracking";
  static const String pasien = "$baseUrl/pasien";
  static const String dokter = "$baseUrl/dokter";
  static const String homeCareUserPoints = "$baseUrl/homecare/user-points";
  static const String homeCarePromos = "$baseUrl/homecare/promos";
  static const String homeCareSettlement = "$baseUrl/homecare/settlement";

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

  static String cekStatusPembayaran(String id) =>
      "$baseUrl/reservasi/cek-status/$id";

  // 🔹 NOTA PELUNASAN
  static String notaDetail(String noPemeriksaan) =>
      "$baseUrl/nota/detail/$noPemeriksaan";
  static const String notaMetodePembayaran = "$baseUrl/nota/metode-pembayaran";
  static const String notaPembayaran = "$baseUrl/nota/pembayaran";
  static String notaInvoice(String noPemeriksaan) =>
      "$baseUrl/nota/invoice/$noPemeriksaan";

  // JadwalPraktek
  static const String jadwalPraktek = "$baseUrl/jadwal-praktek";

  // HOME CARE (optional endpoints used by HomeCareService)
}
