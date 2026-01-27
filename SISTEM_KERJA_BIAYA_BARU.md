# Sistem Kerja Biaya Baru

## Gambaran Umum
Sistem biaya baru ini menggantikan hardcode biaya `25000` yang sebelumnya digunakan di aplikasi Flutter dengan sistem dinamis yang mengambil data dari database backend. Dengan sistem ini, biaya layanan dapat diatur dari sisi server tanpa perlu update aplikasi.

## Komponen Utama

### 1. Backend (Laravel)
- **Tabel Database**: `master_biaya_layanan`
  - `id`
  - `tipe_layanan` (contoh: klinik, homecare, online)
  - `jenis_pasien` (contoh: Umum, BPJS, Asuransi)
  - `biaya_reservasi`
  - `created_at`
  - `updated_at`

- **Endpoint API**: `/biaya-layanan/get-biaya`
  - Menerima parameter: `tipe_layanan` dan `jenis_pasien`
  - Mengembalikan biaya berdasarkan kombinasi tersebut

### 2. Frontend (Flutter)
- **Service**: `BiayaLayananService`
  - Menghubungkan ke API backend untuk mengambil biaya
- **Model**: `BiayaLayananModel`
  - Struktur data untuk biaya layanan
- **Provider**: `BiayaLayananProvider`
  - Mengelola state dan logika pengambilan biaya
- **UI**: Terintegrasi dengan sistem biaya dinamis

## Cara Kerja Sistem

### 1. Pengambilan Biaya
1. Saat user membuka form konfirmasi reservasi
2. Aplikasi mengirim request ke API dengan parameter:
   - `tipe_layanan` (default: "klinik")
   - `jenis_pasien` (default: "Umum")
3. Backend mencari kombinasi tersebut di tabel `master_biaya_layanan`
4. API mengembalikan nilai biaya yang sesuai
5. UI menampilkan biaya tersebut secara dinamis

### 2. Proses Reservasi
1. Saat user membuat reservasi, aplikasi hanya mengirim:
   - `jenis_pasien` (dan `tipe_layanan` jika diperlukan)
   - Tidak mengirim `biaya_reservasi` karena backend yang akan menentukan nilainya
2. Backend mengambil biaya dari database dan menyimpannya ke tabel `reservasi`

## Error Handling
- Jika API gagal atau tidak merespons, sistem menggunakan fallback ke nilai `0`
- Loading indicator ditampilkan saat mengambil data dari API
- Pesan error ditampilkan jika biaya tidak ditemukan

## File-file yang Diubah

### 1. Service Baru
- `lib/core/services/biaya_layanan_service.dart`

### 2. Model Baru
- `lib/core/models/biaya_layanan_model.dart`

### 3. Provider Baru
- `lib/providers/biaya_layanan_provider.dart`

### 4. UI yang Dimodifikasi
- `lib/features/reservasi/screens/Konfirmasi_data_daftar.dart`
- `lib/features/reservasi/screens/reservasi_screens.dart`

### 5. Registrasi Provider
- `lib/main.dart` (menambahkan BiayaLayananProvider ke MultiProvider)

## Keunggulan Sistem Baru
1. **Fleksibilitas**: Biaya dapat diubah dari sisi backend tanpa update aplikasi
2. **Skalabilitas**: Mudah menambahkan kombinasi tipe layanan dan jenis pasien baru
3. **Konsistensi**: Biaya selalu sinkron antara frontend dan backend
4. **Manajemen**: Admin dapat mengelola biaya melalui panel admin backend

## Catatan Penting
- Pastikan tabel `master_biaya_layanan` sudah terisi dengan data biaya yang sesuai
- Endpoint API harus aktif dan dapat diakses oleh aplikasi Flutter
- Default fallback ke `0` digunakan saat API tidak merespons (sebelumnya `25000`)
- Sistem ini menggantikan semua hardcode biaya di aplikasi Flutter

## Integrasi dengan Backend
Backend harus mengimplementasikan:
1. Tabel `master_biaya_layanan` dengan struktur yang sesuai
2. Endpoint `/biaya-layanan/get-biaya` untuk mengambil biaya berdasarkan parameter
3. Logika untuk mengambil dan menyimpan biaya saat membuat reservasi

Sistem ini siap digunakan dan telah diuji untuk memastikan tidak ada lagi hardcode biaya di aplikasi Flutter.