# Modul Katalog Tanaman (Bobby)

## Cakupan

- Katalog: gambar/fallback, nama, pencarian nama/nama ilmiah, kategori,
  filter media/cahaya/ruang, sorting, pagination, pull-to-refresh.
- Detail tanaman: deskripsi, kebutuhan lingkungan/media/perawatan, data yang
  belum diketahui, dan `GuideSection(plantId: plant.id)` milik Nicholas.
- Admin: daftar kelola, tambah/edit semua field yang diizinkan API,
  konfirmasi hapus, feedback sukses/error, dan reload daftar setelah perubahan.
- Tampilan mengikuti theme dan komponen bersama. Route dan access guard
  tetap memakai `lib/app/routes.dart`; tidak ada login atau role baru.

## Backend dan data

Memakai API plants pada repo Django NANEM (PR #40):

| Fungsi | Request |
| --- | --- |
| Daftar | `GET /api/plants/?q=&category=&medium=&sunlight=&space=&sort=&page=1` |
| Detail | `GET /api/plants/<id>/` |
| Tambah | `POST /api/plants/` |
| Edit | `PATCH /api/plants/<id>/` |
| Hapus | `DELETE /api/plants/<id>/` |

Daftar membaca envelope DRF `count`, `next`, `previous`, `results`.
Navigasi halaman tetap mengirim filter dan nomor halaman ke server asal;
tidak mengikuti URL respons ke host lain.

Form tidak mengirim `id`, `perenual_id`, atau timestamp. Nilai angka kosong
menjadi null; boolean nullable tetap membedakan true, false, dan null.
List sunlight dapat berisi beberapa pilihan. Validasi UI memberi feedback
cepat; validasi API tetap berlaku, termasuk nama duplikat.

Rainfall adalah ekuivalen harian dari curah hujan optimal tahunan, bukan
kebutuhan penyiraman. Panduan budidaya tidak disalin ke modul katalog.
DELETE mengikuti cascade backend, termasuk menghapus panduan terkait.

## Sambungan autentikasi bersama (perlu integrasi Jihan)

`CatalogService` menggunakan `Config.baseUrl` dan HTTP native Android/iOS.
Tidak ada package/dependency baru atau data tanaman statis dalam aplikasi.

Login bersama dan `core/api/api_client.dart` masih placeholder pada basis
branch ini. Service menyediakan `CatalogService.cookieProvider`, dengan pola
yang sama seperti `GuideService.cookieProvider`. PIC autentikasi perlu
menghubungkan callback tersebut ke header cookie dari session login bersama.
Nilainya berupa string header cookie (`sessionid=...`), atau null saat logout.
Jangan menaruh credential/cookie asli di kode, Git, atau UI.

Service tidak membuat session, tidak menyimpulkan admin dari username, dan
tidak mengubah logika login. Tanpa cookie yang valid, backend tetap menolak
akses. Respons 401 memanggil `AuthState.instance.handleUnauthorized()`.
Jika API client bersama sudah tersedia, transport service ini dapat dialihkan
ke client tersebut tanpa mengubah model atau halaman katalog.

Untuk backend lokal Android Emulator, pengaturan bersama `Config.baseUrl`
menggunakan `http://10.0.2.2:<port>`. Pastikan backend yang dipakai sudah memuat
API plants. Jangan mengganti ke endpoint web HTML atau membuat data cadangan
statis ketika API belum tersedia.

Koneksi mobile ke PWS belum dapat diklaim selesai sebelum API dideploy dan
session bersama disambungkan. `GuideSection` mengikuti implementasi/PR Nicholas;
file panduan tidak diubah dalam pekerjaan katalog.

## Verifikasi

```sh
flutter analyze --no-pub
flutter test --no-pub test/features/catalog
```

Tes memakai fixture khusus test dan server HTTP loopback, tanpa akses ke PWS.
Widget menerima service opsional untuk testing; aplikasi normal menggunakan
`CatalogService.instance`.

Setelah integrasi session/PWS siap, uji dengan akun user dan staff asli:
search/filter/pagination, tambah/edit/hapus dari mobile, lalu muat ulang web
untuk memastikan kedua platform membaca database yang sama.
