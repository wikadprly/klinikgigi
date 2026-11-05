# 3K Dental Care

Aplikasi klinik gigi berbasis Flutter yang mencakup reservasi online, layanan
dental home care, riwayat pemeriksaan, reward pasien, dan pembayaran Midtrans.
Proyek ini juga dapat dibangun sebagai aplikasi web untuk portofolio.

## Fitur

- Reservasi poliklinik: pilih poli, dokter, jadwal, dan keluhan.
- Dental Home Care: pilih jadwal dokter, atur lokasi, estimasi biaya transport,
  dan booking kunjungan ke rumah.
- Pembayaran melalui Midtrans (mobile memakai WebView, web membuka halaman
  pembayaran di tab baru).
- Riwayat pemeriksaan poliklinik dan home care.
- Reward dan promo pasien.
- Profil pasien, unggah foto profil, ubah kata sandi, dan OTP.
- Tampilan responsif: di layar lebar aplikasi ditampilkan dalam frame ponsel.

## Teknologi

- Flutter 3.35 (Dart 3.9)
- Provider untuk state management
- `http` untuk REST API
- `shared_preferences` untuk sesi dan token
- `image_picker`, `webview_flutter`, `url_launcher`, `intl`

## Mode Demo

Mode demo aktif secara default sehingga aplikasi web dapat dijalankan tanpa
backend dan tanpa login. Data poli, dokter, jadwal, promo, reward, dan riwayat
diisi otomatis.

Variabel yang tersedia (melalui `--dart-define`):

| Variabel | Default | Keterangan |
| --- | --- | --- |
| `DEMO_MODE` | `true` | `true` memakai data contoh, `false` memakai API asli |
| `API_BASE_URL` | `http://127.0.0.1:8000/api` | Base URL backend Laravel |

## Menjalankan

```bash
flutter pub get
flutter run -d chrome
```

Menjalankan tanpa mode demo (memerlukan backend):

```bash
flutter run -d chrome \
  --dart-define=DEMO_MODE=false \
  --dart-define=API_BASE_URL=https://domain-backend-anda.com/api
```

## Build Web

```bash
flutter build web --release --dart-define=DEMO_MODE=true
```

Hasil build berada di `build/web`.

Jika di-host di sub-path (misalnya GitHub Pages `username.github.io/repo`),
tambahkan base href:

```bash
flutter build web --release --base-href /nama-repo/ --dart-define=DEMO_MODE=true
```

## Deploy

### Netlify Drop

1. Jalankan `flutter build web --release --dart-define=DEMO_MODE=true`.
2. Buka <https://app.netlify.com/drop>.
3. Unggah atau seret folder `build/web`.
4. Situs langsung online dan dapat dibagikan sebagai portofolio.

### Firebase Hosting

```bash
npm install -g firebase-tools
firebase login
firebase init hosting
```

Pilih folder publik `build/web`, lalu:

```bash
flutter build web --release --dart-define=DEMO_MODE=true
firebase deploy --only hosting
```

### Vercel

Gunakan `build/web` sebagai Output Directory dan build command berikut:

```bash
flutter build web --release --dart-define=DEMO_MODE=true
```

Pastikan Flutter SDK tersedia pada environment build Vercel.

## Catatan Web

- Pembayaran Midtrans di web membuka halaman pembayaran di tab baru, lalu status
  pembayaran dicek melalui polling API.
- Unggah foto profil memakai `XFile` sehingga tidak bergantung pada `dart:io`.
- Tanpa backend, gunakan mode demo agar seluruh halaman tetap dapat ditampilkan.

## Struktur Singkat

```
lib/
  config/           konfigurasi API dan mode demo
  core/             model, service, storage
  features/         auth, reservasi, dentalhome, riwayat, profile, settings
  providers/        state management
  theme/            warna dan tipografi
web/                konfigurasi dan aset web
```
