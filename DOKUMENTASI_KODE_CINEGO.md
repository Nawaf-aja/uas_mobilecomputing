# Dokumentasi Kode Aplikasi CineGo

Dokumen ini dibuat sebagai pegangan saat presentasi atau ditanya dosen tentang bagian kode aplikasi. Aplikasi CineGo adalah prototype Flutter untuk pemesanan tiket bioskop dengan data dummy dari file JSON lokal.

## 1. Gambaran Umum Project

Project ini memakai Flutter dan Dart. Entry point aplikasi ada di:

```text
lib/main.dart
```

Struktur utama:

```text
lib/
  main.dart
  core/
    app_scope.dart
    constants.dart
    models.dart
    shared_widgets.dart
  features/
    auth/
    cinema/
    film/
    home/
    onboarding/
    profile/

assets/
  data/
    auth.json
    cinego_data.json
    cinema_types.json
    movies.json
  fonts/
    Inter.ttf
```

Data aplikasi tidak dari database/backend, tetapi dari JSON lokal di folder `assets/data/`.

## 2. Konfigurasi Asset dan Font

File:

```text
pubspec.yaml
```

Bagian penting:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/data/
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter.ttf
```

Penjelasan:

- `uses-material-design: true` mengaktifkan icon Material seperti `Icons.home`, `Icons.search`, dan lain-lain.
- `assets: - assets/data/` membuat semua JSON di folder `assets/data` bisa dibaca aplikasi.
- `fonts` mendaftarkan font Inter supaya tampilan konsisten di semua device.

Font Inter dipakai di:

```text
lib/main.dart
```

Syntax:

```dart
fontFamily: 'Inter',
```

Jawaban kalau ditanya:

> Font Inter diatur global di `ThemeData` pada `lib/main.dart`, dan file font-nya didaftarkan di `pubspec.yaml`.

## 3. Entry Point Aplikasi

File:

```text
lib/main.dart
```

Kode utama:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const DataGate(child: CineGoApp()));
}
```

Penjelasan:

- `main()` adalah fungsi pertama yang dijalankan Flutter.
- `WidgetsFlutterBinding.ensureInitialized()` memastikan Flutter siap sebelum membaca asset.
- `SystemChrome.setSystemUIOverlayStyle(...)` mengatur status bar.
- `runApp(...)` menjalankan widget utama aplikasi.
- `DataGate` membungkus aplikasi supaya data JSON dimuat sebelum UI dipakai.

Widget utama:

```dart
class CineGoApp extends StatelessWidget
```

Bagian ini membuat `MaterialApp`, tema warna, font, dan halaman pertama:

```dart
home: const SplashScreen(),
```

Jawaban kalau ditanya:

> Aplikasi mulai dari `main()`, lalu `runApp` menjalankan `DataGate`, kemudian `CineGoApp`, dan halaman pertama adalah `SplashScreen`.

## 4. Warna Global

File:

```text
lib/core/constants.dart
```

Isi penting:

```dart
class AppColors {
  static const red = Color(0xFFFF0717);
  static const bg = Color(0xFF111116);
  static const surface = Color(0xFF1B1B24);
  static const field = Color(0xFF2A2A33);
  static const muted = Color(0xFF9A9AA6);
}
```

Penjelasan:

- `AppColors.red` dipakai untuk warna utama merah CineGo.
- `AppColors.bg` dipakai sebagai background gelap.
- `AppColors.surface` dipakai untuk card, field, bottom navigation.
- `static const` artinya nilai warna bisa dipanggil langsung tanpa membuat objek.

Contoh pemakaian:

```dart
color: AppColors.red
```

## 5. Cara Aplikasi Membaca JSON

File:

```text
lib/core/app_scope.dart
```

Data dibaca di class:

```dart
class DataGate extends StatelessWidget
```

Syntax utama:

```dart
final appRaw = await rootBundle.loadString('assets/data/cinego_data.json');
final moviesRaw = await rootBundle.loadString('assets/data/movies.json');
final authRaw = await rootBundle.loadString('assets/data/auth.json');
final cinemaTypesRaw = await rootBundle.loadString(
  'assets/data/cinema_types.json',
);
```

Penjelasan:

- `rootBundle.loadString(...)` membaca file asset sebagai teks.
- `await` dipakai karena proses baca file bersifat asynchronous.
- Setelah dibaca, teks JSON diubah menjadi object Map memakai:

```dart
jsonDecode(appRaw) as Map<String, dynamic>
```

Lalu semua data dikirim ke model:

```dart
return CineData.fromJson(...);
```

## 6. AppScope / InheritedWidget

File:

```text
lib/core/app_scope.dart
```

Class:

```dart
class AppScope extends InheritedWidget
```

Fungsi:

```dart
static CineData of(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<AppScope>()!.data;
}
```

Penjelasan:

- `AppScope` menyimpan semua data JSON agar bisa diakses dari halaman mana pun.
- Kalau halaman butuh data film, bioskop, atau user, cukup panggil:

```dart
final data = AppScope.of(context);
```

Contoh di Home:

```dart
final data = AppScope.of(context);
final movies = data.movies;
```

Jawaban kalau ditanya:

> Data JSON disimpan di `AppScope`, jadi tidak perlu baca file JSON berulang-ulang di setiap halaman.

## 7. Model Data

File:

```text
lib/core/models.dart
```

Model utama:

```dart
class CineData
class AuthUser
class BannerData
class Movie
class Cinema
class CinemaType
```

### 7.1 CineData

`CineData` adalah container utama semua data:

```dart
final List<AuthUser> users;
final List<BannerData> banners;
final List<Movie> movies;
final List<Cinema> cinemas;
final List<CinemaType> cinemaTypes;
```

### 7.2 Movie

Model film:

```dart
class Movie {
  final String id;
  final String title;
  final String genre;
  final String duration;
  final String year;
  final double rating;
  final String status;
  final String age;
  final String poster;
  final String backdrop;
  final String synopsis;
  final List<String> tags;
}
```

Field `status` dipakai untuk tab Film:

```text
sedang_tayang
presale
segera_tayang
```

### 7.3 Cinema

Model bioskop:

```dart
class Cinema {
  final String id;
  final String name;
  final String type;
  final String city;
  final String distance;
  final String address;
  final String image;
  final List<String> facilities;
}
```

Field `type` menghubungkan bioskop ke tipe bioskop di `cinema_types.json`, misalnya `cgv`, `xxi`, atau `cinepolis`.

### 7.4 CinemaType

Model tipe bioskop:

```dart
class CinemaType {
  final String id;
  final String name;
  final List<String> formats;
  final List<String> dates;
  final Map<String, List<String>> times;
}
```

Dipakai untuk jadwal tayang berbeda berdasarkan tipe bioskop dan format studio.

Jawaban kalau ditanya:

> Struktur data JSON diubah menjadi object Dart di `models.dart`. Contohnya JSON film diubah ke class `Movie`.

## 8. File JSON

### 8.1 auth.json

File:

```text
assets/data/auth.json
```

Isi login dummy:

```json
{
  "email": "jason.ranti@gmail.com",
  "password": "12345678"
}
```

Dipakai di:

```text
lib/features/auth/login_screen.dart
```

### 8.2 movies.json

File:

```text
assets/data/movies.json
```

Berisi daftar film, poster dummy, rating, genre, dan status.

Field penting:

```json
"status": "sedang_tayang"
```

Status ini dipakai untuk filter tab Film.

### 8.3 cinego_data.json

File:

```text
assets/data/cinego_data.json
```

Berisi:

- banner home
- daftar bioskop

### 8.4 cinema_types.json

File:

```text
assets/data/cinema_types.json
```

Berisi tipe bioskop dan jam tayang:

```json
{
  "id": "xxi",
  "formats": ["Regular", "The Premiere", "IMAX"],
  "times": {
    "Regular": ["11:00", "13:45", "16:20"]
  }
}
```

Jawaban kalau ditanya:

> Jadwal tayang bukan hardcode di screen, tapi diambil dari `cinema_types.json`.

### 8.5 transactions.json

File:

```text
assets/data/transactions.json
```

Berisi riwayat transaksi dummy:

- kode transaksi
- judul film
- nama bioskop
- format studio
- tanggal dan jam
- kursi
- metode pembayaran
- total pembayaran
- status transaksi
- poster film

Dipakai di:

```text
lib/features/profile/transaction_history_screen.dart
```

Jawaban kalau ditanya:

> Riwayat transaksi diambil dari `assets/data/transactions.json`, lalu diubah menjadi model `TransactionHistory` di `models.dart`.

## 9. Shared Widgets

File:

```text
lib/core/shared_widgets.dart
```

Berisi widget yang dipakai berulang:

```dart
NetImage
HeroImage
RedTopAccent
RedButton
BackBubble
RatingBadge
SmallTag
TopTitle
Segments
```

### 9.1 NetImage

Fungsi:

> Menampilkan gambar dari URL dummy.

Syntax:

```dart
Image.network(
  url,
  fit: BoxFit.cover,
  errorBuilder: ...
)
```

`errorBuilder` dipakai kalau gambar gagal dimuat.

### 9.2 RedTopAccent

Fungsi:

> Membuat accent merah abstrak di bagian atas halaman.

Syntax:

```dart
const RedTopAccent(height: 290)
```

Di dalamnya memakai `RadialGradient`.

### 9.3 RedButton

Fungsi:

> Tombol merah utama aplikasi.

Syntax:

```dart
RedButton(
  label: 'Beli Tiket',
  onPressed: buyTicket,
)
```

### 9.4 BackBubble

Fungsi:

> Tombol kembali berbentuk lingkaran.

Syntax:

```dart
onPressed: () => Navigator.pop(context)
```

## 10. Onboarding dan Splash

Folder:

```text
lib/features/onboarding/
```

File:

```text
splash_screen.dart
onboarding_screen.dart
```

### 10.1 SplashScreen

Fungsi:

> Menampilkan logo CineGo sebentar lalu pindah ke onboarding.

Syntax pindah halaman:

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
);
```

`pushReplacement` artinya halaman splash diganti, jadi user tidak bisa back ke splash.

### 10.2 OnboardingScreen

Menggunakan:

```dart
PageView.builder
PageController
AnimatedContainer
```

Fungsi:

- `PageView.builder` membuat slide onboarding.
- `PageController` mengontrol slide.
- `AnimatedContainer` membuat indikator slide animasi.

## 11. Login dan Register

Folder:

```text
lib/features/auth/
```

File:

```text
login_screen.dart
register_screen.dart
widgets/auth_shell.dart
```

### 11.1 AuthShell

File:

```text
lib/features/auth/widgets/auth_shell.dart
```

Fungsi:

> Layout reusable untuk login dan register.

Widget ini memakai:

```dart
TextEditingController
TextField
setState
ListView
```

`TextEditingController` dipakai untuk mengambil input user:

```dart
controllers[field]!.text
```

Password bisa disembunyikan/dilihat dengan:

```dart
obscureText: field.contains('Sandi') && obscurePassword
```

Icon mata mengubah state:

```dart
setState(() => obscurePassword = !obscurePassword)
```

### 11.2 LoginScreen

File:

```text
lib/features/auth/login_screen.dart
```

Fungsi:

> Validasi email dan password dari `auth.json`.

Syntax validasi:

```dart
final users = AppScope.of(context).users;
final isValid = users.any(
  (user) =>
      user.email == values['Email'] &&
      user.password == values['Kata Sandi'],
);
```

Kalau salah:

```dart
ScaffoldMessenger.of(context).showSnackBar(...)
```

Kalau benar:

```dart
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const MainShell()),
);
```

Akun dummy:

```text
Email: jason.ranti@gmail.com
Password: 12345678
```

Jawaban kalau ditanya:

> Login tidak memakai database, tetapi mencocokkan input dengan data user di `assets/data/auth.json`.

## 12. MainShell dan Bottom Navigation

File:

```text
lib/features/home/main_shell.dart
```

Fungsi:

> Menjadi container halaman utama setelah login.

Halaman tab:

```dart
final pages = [
  HomeScreen(...),
  const FilmListScreen(),
  const CinemaListScreen(),
  const ProfileScreen(),
];
```

Bottom navigation:

```dart
NavigationBar(
  selectedIndex: tab,
  onDestinationSelected: (value) => setState(() => tab = value),
)
```

Penjelasan:

- `tab` menyimpan index menu aktif.
- `setState` mengubah halaman ketika tab diklik.
- `HomeScreen` diberi callback:

```dart
onSeeMovies: () => setState(() => tab = 1)
onSeeCinemas: () => setState(() => tab = 2)
```

Jawaban kalau ditanya:

> Tombol “Lihat Semua” dari Home pindah ke halaman Film lewat callback dari `MainShell`.

## 13. Home Screen

File:

```text
lib/features/home/home_screen.dart
```

Fitur:

- header Halo Jason
- search film
- banner promo
- carousel film sedang tayang
- kartu bioskop terdekat
- rekomendasi film
- accent merah di atas

### 13.1 Accent merah home

Syntax:

```dart
return Stack(
  children: [
    const RedTopAccent(height: 290),
    SafeArea(...)
  ],
);
```

Penjelasan:

> `Stack` dipakai agar accent merah berada di belakang konten.

### 13.2 Search di Home

State query:

```dart
String query = '';
```

Filter:

```dart
final normalized = query.toLowerCase();
final movies = normalized.isEmpty
    ? data.movies
    : data.movies.where((movie) =>
        movie.title.toLowerCase().contains(normalized) ||
        movie.genre.toLowerCase().contains(normalized) ||
        movie.tags.any((tag) => tag.toLowerCase().contains(normalized))
      ).toList();
```

TextField:

```dart
SearchBox(onChanged: (value) => setState(() => query = value))
```

Penjelasan:

> Saat user mengetik, `query` berubah, lalu `setState` membuat UI refresh dan daftar film terfilter.

### 13.3 Carousel film zoom tengah

Controller:

```dart
movieController = PageController(viewportFraction: .78, initialPage: 1);
```

Animasi:

```dart
final distance = (page - index).abs().clamp(0.0, 1.0);
final scale = 1.0 - (distance * .16);
Transform.scale(scale: scale, child: ...)
```

Penjelasan:

- Film yang berada di tengah punya `distance` kecil.
- Kalau `distance` kecil, `scale` mendekati `1.0`, jadi terlihat lebih besar.
- Film samping lebih kecil karena `scale` berkurang.

Jawaban kalau ditanya:

> Efek zoom carousel dibuat di `HomeScreen` menggunakan `PageController`, `AnimatedBuilder`, dan `Transform.scale`.

## 14. Halaman Film

File:

```text
lib/features/film/film_list_screen.dart
```

Fitur:

- tab Sedang Tayang
- tab Tiket Presale
- tab Segera Tayang
- search film
- grid poster film

State:

```dart
final searchController = TextEditingController();
var activeStatus = 'sedang_tayang';
var showSearch = false;
```

Tab:

```dart
final tabs = const [
  ('sedang_tayang', 'Sedang Tayang'),
  ('presale', 'Tiket Presale'),
  ('segera_tayang', 'Segera Tayang'),
];
```

Filter:

```dart
final matchesTab = movie.status == activeStatus;
final matchesSearch =
    query.isEmpty ||
    movie.title.toLowerCase().contains(query) ||
    movie.genre.toLowerCase().contains(query) ||
    movie.tags.any((tag) => tag.toLowerCase().contains(query));
return matchesTab && matchesSearch;
```

Penjelasan:

- `matchesTab` memastikan film sesuai tab.
- `matchesSearch` memastikan film sesuai keyword search.
- Film hanya tampil kalau dua-duanya benar.

Jawaban kalau ditanya:

> Tab Film bekerja dengan mencocokkan `movie.status` dari `movies.json` terhadap `activeStatus`.

## 15. Widget Poster Film

File:

```text
lib/features/film/widgets/movie_poster.dart
```

Fungsi:

> Menampilkan poster film dan membuka detail film saat diklik.

Syntax navigasi:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => FilmDetailScreen(
      movie: movie,
      initialCinema: initialCinema,
    ),
  ),
)
```

`initialCinema` dipakai saat user masuk dari detail bioskop, supaya bioskop otomatis terpilih.

## 16. Detail Film

File:

```text
lib/features/film/film_detail_screen.dart
```

Fitur:

- detail film
- tombol hati/favorite
- pilih bioskop
- tombol Beli Tiket hanya lanjut kalau bioskop sudah dipilih

State:

```dart
Cinema? selectedCinema;
var isFavorite = false;
```

### 16.1 Auto pilih bioskop dari detail bioskop

Syntax:

```dart
selectedCinema = widget.initialCinema;
```

Penjelasan:

> Kalau detail film dibuka dari halaman detail bioskop, nilai `initialCinema` dikirim, lalu otomatis menjadi `selectedCinema`.

### 16.2 Validasi sebelum beli tiket

Syntax:

```dart
void buyTicket() {
  final cinema = selectedCinema;
  if (cinema == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pilih bioskop dulu sebelum beli tiket.')),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ScheduleScreen(movie: widget.movie, cinema: cinema),
    ),
  );
}
```

Penjelasan:

- Kalau `selectedCinema == null`, user belum pilih bioskop.
- Aplikasi menampilkan `SnackBar`.
- Kalau sudah pilih, lanjut ke `ScheduleScreen`.

### 16.3 Border merah bioskop terpilih

Widget:

```dart
SelectableCinemaCard
```

Syntax:

```dart
border: Border.all(
  color: selected ? AppColors.red : Colors.white10,
  width: selected ? 1.6 : 1,
)
```

Jawaban kalau ditanya:

> Border merah muncul karena property `selected` true, lalu warna border berubah menjadi `AppColors.red`.

### 16.4 Tombol hati

Syntax:

```dart
onPressed: () => setState(() => isFavorite = !isFavorite)
```

Icon:

```dart
isFavorite ? Icons.favorite : Icons.favorite_border
```

## 17. Halaman Jadwal

File:

```text
lib/features/film/schedule_screen.dart
```

Fitur:

- menerima film dan bioskop terpilih
- membaca tipe bioskop
- memilih tanggal
- memilih format studio
- memilih jam tayang

Constructor:

```dart
const ScheduleScreen({
  super.key,
  required this.movie,
  required this.cinema,
});
```

Ambil tipe bioskop:

```dart
final cinemaType = AppScope.of(context).typeForCinema(widget.cinema);
```

Ambil format dan jam:

```dart
final selectedFormat = cinemaType.formats[format];
final times = cinemaType.times[selectedFormat] ?? const <String>[];
```

Penjelasan:

- `cinemaType.formats` berisi format studio seperti Regular, IMAX, 4DX.
- `cinemaType.times[selectedFormat]` mengambil jam tayang sesuai format studio.

State pilihan:

```dart
int date = 0;
int format = 0;
int time = 0;
```

Saat format studio berubah:

```dart
onTap: () => setState(() {
  format = i;
  time = 0;
})
```

Penjelasan:

> Saat format studio diganti, jam tayang di-reset ke index 0 supaya pilihan jam tidak salah.

## 18. Halaman Pilih Kursi

File:

```text
lib/features/film/seat_screen.dart
```

Fitur:

- grid kursi 8 x 8
- kursi terisi
- kursi dipilih
- lanjut pembayaran

State:

```dart
final selected = <String>{'F1', 'F2'};
final filled = {'B5', 'B6', 'C4', 'D7', 'E3', 'G8'};
```

Generate kursi:

```dart
final row = String.fromCharCode(65 + (i ~/ 8));
final id = '$row${(i % 8) + 1}';
```

Penjelasan:

- `i ~/ 8` membagi integer untuk menentukan baris.
- `String.fromCharCode(65)` menghasilkan huruf A.
- Maka kursi menjadi A1, A2, B1, dan seterusnya.

Saat kursi diklik:

```dart
onTap: isFilled
    ? null
    : () => setState(() =>
        isSelected ? selected.remove(id) : selected.add(id)
      )
```

Jawaban kalau ditanya:

> Kursi dibuat otomatis dari `GridView.builder`, bukan ditulis satu-satu.

## 19. Pembayaran

File:

```text
lib/features/film/payment_screen.dart
```

Fitur:

- pilih metode pembayaran
- checkbox bagikan kode booking
- tombol bayar sekarang
- dialog pembayaran berhasil

State:

```dart
var selectedPayment = 'GoPay';
var shareBooking = false;
```

Metode pembayaran:

```dart
final payments = ['GoPay', 'OVO', 'Transfer Bank', 'Kartu Debit'];
```

Membuat chip pembayaran:

```dart
payments.map(
  (payment) => PayChip(
    label: payment,
    selected: selectedPayment == payment,
    onTap: () => setState(() => selectedPayment = payment),
  ),
)
```

Dialog berhasil:

```dart
showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Pembayaran Berhasil'),
    content: Text(
      'Tiket ${widget.movie.title} berhasil dibayar dengan $selectedPayment.',
    ),
  ),
)
```

Jawaban kalau ditanya:

> Metode pembayaran bukan hanya style, tetapi state-nya berubah lewat `selectedPayment`, lalu dipakai di dialog berhasil.

## 20. Halaman Bioskop

Folder:

```text
lib/features/cinema/
```

File:

```text
cinema_list_screen.dart
cinema_detail_screen.dart
widgets/cinema_tile.dart
```

### 20.1 CinemaListScreen

Menampilkan daftar bioskop:

```dart
for (final cinema in data.cinemas) CinemaTile(cinema: cinema)
```

### 20.2 CinemaTile

Fungsi:

> Card bioskop yang bisa diklik.

Saat diklik:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => CinemaDetailScreen(cinema: cinema)),
)
```

### 20.3 CinemaDetailScreen

Menampilkan detail bioskop dan daftar film.

Bagian penting:

```dart
MoviePoster(movie: movies[i], initialCinema: cinema)
```

Penjelasan:

> Saat film diklik dari detail bioskop, `initialCinema` dikirim ke detail film, sehingga bioskop otomatis terpilih.

## 21. Profile dan Logout

File:

```text
lib/features/profile/profile_screen.dart
```

Item `Riwayat Transaksi` di Profile membuka halaman:

```text
lib/features/profile/transaction_history_screen.dart
```

Syntax navigasi:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
)
```

Logout:

```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (route) => false,
)
```

Penjelasan:

- Pindah ke login.
- Semua halaman sebelumnya dihapus dari stack.
- User tidak bisa menekan back untuk kembali ke home setelah logout.

## 21A. Riwayat Transaksi

File:

```text
lib/features/profile/transaction_history_screen.dart
```

Fitur:

- menampilkan ringkasan jumlah transaksi
- menghitung total tiket
- menghitung total pengeluaran
- menampilkan card riwayat transaksi
- menampilkan poster, film, bioskop, tanggal, jam, kursi, metode pembayaran, total, dan status

Data diambil dari:

```dart
final transactions = AppScope.of(context).transactions;
```

Ringkasan transaksi:

```dart
final totalTickets = transactions.fold<int>(
  0,
  (sum, item) => sum + item.seats.length,
);
```

Penjelasan:

> `fold` dipakai untuk menjumlahkan data dari list. Di sini total tiket dihitung dari jumlah kursi setiap transaksi.

Total pengeluaran:

```dart
final totalSpent = transactions.fold<int>(
  0,
  (sum, item) => sum + item.total,
);
```

Card transaksi dibuat dengan:

```dart
for (final transaction in transactions)
  TransactionCard(transaction: transaction)
```

Jawaban kalau ditanya:

> Halaman riwayat transaksi ada di `transaction_history_screen.dart`. Datanya dari `transactions.json`, modelnya `TransactionHistory`, dan ringkasannya dihitung memakai `fold`.

## 22. Syntax Flutter/Dart yang Sering Ditanya

### 22.1 StatelessWidget vs StatefulWidget

`StatelessWidget`:

> Dipakai kalau tampilan tidak butuh perubahan state lokal.

Contoh:

```dart
class CineGoApp extends StatelessWidget
```

`StatefulWidget`:

> Dipakai kalau tampilan berubah saat user klik/ketik/pilih sesuatu.

Contoh:

```dart
class FilmListScreen extends StatefulWidget
```

State-nya:

```dart
class _FilmListScreenState extends State<FilmListScreen>
```

### 22.2 setState

Fungsi:

> Memberi tahu Flutter bahwa data berubah dan UI perlu digambar ulang.

Contoh:

```dart
setState(() => activeStatus = tab.$1)
```

### 22.3 Navigator

Pindah halaman:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => TargetScreen()),
)
```

Mengganti halaman:

```dart
Navigator.pushReplacement(...)
```

Kembali:

```dart
Navigator.pop(context)
```

### 22.4 FutureBuilder

Dipakai untuk data asynchronous:

```dart
FutureBuilder<CineData>(
  future: _load(),
  builder: (context, snapshot) { ... }
)
```

Di project ini dipakai untuk menunggu JSON selesai dibaca.

### 22.5 ListView dan GridView

`ListView`:

> Untuk daftar vertikal atau horizontal.

`GridView.builder`:

> Untuk grid poster film atau kursi.

Contoh:

```dart
GridView.builder(
  itemCount: movies.length,
  itemBuilder: (_, i) => MoviePoster(movie: movies[i]),
)
```

### 22.6 map, where, any

`map`:

> Mengubah list data menjadi list widget.

```dart
data.banners.map((item) => PromoBanner(banner: item)).toList()
```

`where`:

> Menyaring data.

```dart
data.movies.where((movie) => movie.status == 'sedang_tayang')
```

`any`:

> Mengecek apakah minimal satu item memenuhi kondisi.

```dart
movie.tags.any((tag) => tag.toLowerCase().contains(query))
```

### 22.7 Null Safety

Contoh:

```dart
Cinema? selectedCinema;
```

Tanda `?` artinya nilai boleh null.

Validasi:

```dart
if (cinema == null) { ... }
```

## 23. Alur Aplikasi

Urutan layar:

```text
SplashScreen
  -> OnboardingScreen
  -> LoginScreen
  -> MainShell
      -> HomeScreen
      -> FilmListScreen
      -> CinemaListScreen
      -> ProfileScreen
```

Alur beli tiket dari Home/Film:

```text
Home/Film
  -> FilmDetailScreen
  -> pilih bioskop
  -> ScheduleScreen
  -> SeatScreen
  -> PaymentScreen
  -> Pembayaran Berhasil
```

Alur beli tiket dari Bioskop:

```text
CinemaListScreen
  -> CinemaDetailScreen
  -> pilih film
  -> FilmDetailScreen dengan bioskop otomatis terpilih
  -> ScheduleScreen
  -> SeatScreen
  -> PaymentScreen
```

## 24. Daftar Pertanyaan dan Jawaban Cepat

### Q: Data film diambil dari mana?

A: Dari `assets/data/movies.json`, dibaca di `lib/core/app_scope.dart`, lalu diubah ke model `Movie` di `lib/core/models.dart`.

### Q: Login pakai database?

A: Tidak. Login memakai data dummy dari `assets/data/auth.json`.

### Q: Kode validasi login di mana?

A: Di `lib/features/auth/login_screen.dart`, bagian `users.any(...)`.

### Q: Kode tab Film di mana?

A: Di `lib/features/film/film_list_screen.dart`, variable `activeStatus` dan function `filteredMovies`.

### Q: Kode search Film di mana?

A: Di `lib/features/film/film_list_screen.dart`, memakai `TextEditingController` dan `filteredMovies`.

### Q: Kode search Home di mana?

A: Di `lib/features/home/home_screen.dart`, variable `query` dan filter `data.movies.where(...)`.

### Q: Kode carousel zoom di Home di mana?

A: Di `lib/features/home/home_screen.dart`, bagian `PageView.builder`, `AnimatedBuilder`, dan `Transform.scale`.

### Q: Kode warna merah abstrak di atas halaman di mana?

A: Widget-nya di `lib/core/shared_widgets.dart` bernama `RedTopAccent`, dipakai di Home, Film, Detail, Jadwal, Kursi, dan Payment.

### Q: Kode pilih bioskop sebelum beli tiket di mana?

A: Di `lib/features/film/film_detail_screen.dart`, function `buyTicket()` dan widget `SelectableCinemaCard`.

### Q: Border merah bioskop terpilih di mana?

A: Di `SelectableCinemaCard`, property `Border.all(color: selected ? AppColors.red : Colors.white10)`.

### Q: Jadwal tayang beda-beda berdasarkan bioskop di mana?

A: Data ada di `assets/data/cinema_types.json`, pemakaiannya di `lib/features/film/schedule_screen.dart`.

### Q: Kalau masuk dari menu Bioskop, kenapa bioskop otomatis terpilih?

A: Karena `CinemaDetailScreen` mengirim `initialCinema` ke `MoviePoster`, lalu `MoviePoster` mengirim ke `FilmDetailScreen`.

### Q: Kode pembayaran berhasil di mana?

A: Di `lib/features/film/payment_screen.dart`, function `pay()` memakai `showDialog`.

### Q: Kode metode pembayaran bisa dipilih di mana?

A: Di `payment_screen.dart`, variable `selectedPayment` dan widget `PayChip`.

### Q: Kode logout di mana?

A: Di `lib/features/profile/profile_screen.dart`, memakai `Navigator.pushAndRemoveUntil`.

### Q: Kode riwayat transaksi di mana?

A: Di `lib/features/profile/transaction_history_screen.dart`, datanya dari `assets/data/transactions.json`.

### Q: Font Inter dipasang di mana?

A: Di `pubspec.yaml` untuk asset font dan di `lib/main.dart` pada `ThemeData(fontFamily: 'Inter')`.

## 25. Ringkasan File Penting

| Fitur | File |
|---|---|
| Entry aplikasi | `lib/main.dart` |
| Load JSON | `lib/core/app_scope.dart` |
| Model data | `lib/core/models.dart` |
| Warna global | `lib/core/constants.dart` |
| Widget reusable | `lib/core/shared_widgets.dart` |
| Splash | `lib/features/onboarding/splash_screen.dart` |
| Onboarding | `lib/features/onboarding/onboarding_screen.dart` |
| Login | `lib/features/auth/login_screen.dart` |
| Register | `lib/features/auth/register_screen.dart` |
| Layout auth | `lib/features/auth/widgets/auth_shell.dart` |
| Bottom navigation | `lib/features/home/main_shell.dart` |
| Home | `lib/features/home/home_screen.dart` |
| List film | `lib/features/film/film_list_screen.dart` |
| Detail film | `lib/features/film/film_detail_screen.dart` |
| Jadwal | `lib/features/film/schedule_screen.dart` |
| Kursi | `lib/features/film/seat_screen.dart` |
| Pembayaran | `lib/features/film/payment_screen.dart` |
| List bioskop | `lib/features/cinema/cinema_list_screen.dart` |
| Detail bioskop | `lib/features/cinema/cinema_detail_screen.dart` |
| Profile | `lib/features/profile/profile_screen.dart` |
| Riwayat transaksi | `lib/features/profile/transaction_history_screen.dart` |

## 26. Cara Menjelaskan Project Singkat

Kalimat presentasi singkat:

> CineGo adalah aplikasi Flutter prototype untuk pemesanan tiket bioskop. Data user, film, bioskop, dan jadwal berasal dari file JSON lokal. Aplikasi menggunakan `AppScope` untuk membagikan data ke seluruh halaman, `StatefulWidget` untuk fitur interaktif seperti search, tab, pilih kursi, pilih pembayaran, dan `Navigator` untuk perpindahan halaman. Font Inter dipasang global melalui `ThemeData`, dan komponen yang sering dipakai seperti tombol merah, gambar, rating, dan accent merah dibuat reusable di `shared_widgets.dart`.
