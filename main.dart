// =====================================================================
//  MOCKUP WIREFRAME HITAM-PUTIH - APLIKASI WISATA (FLUTTER)
// ---------------------------------------------------------------------
//  ALUR APLIKASI:
//    main() -> MyApp -> HomeScreen
//    HomeScreen   --(Enter di Search / tombol Explore)--> ResultScreen
//    ResultScreen --(tap kartu tempat)------------------> DetailScreen
//    DetailScreen --(tombol kembali)--------------------> ResultScreen
//
//  PERSIAPAN GAMBAR (WAJIB sebelum run):
//    1. Buat folder  assets/images/  (sejajar dengan folder lib)
//    2. Masukkan gambar: mcway.jpg, bixby.jpg, pfeiffer.jpg
//    3. Daftarkan di pubspec.yaml (perhatikan indentasi 2 spasi):
//         flutter:
//           uses-material-design: true
//           assets:
//             - assets/images/
//    4. Jalankan  flutter pub get  lalu  flutter run
//       (kalau menambah gambar saat app jalan, lakukan HOT RESTART)
// =====================================================================

import 'package:flutter/material.dart'; // library widget Material

// ---------------------------------------------------------------------
//  main(): titik awal program, menjalankan widget MyApp
// ---------------------------------------------------------------------
void main() {
  runApp(const MyApp()); // menampilkan MyApp ke layar
}

// ---------------------------------------------------------------------
//  MyApp: widget akar aplikasi (StatelessWidget = tidak punya state)
//  Mengatur tema dan screen pertama yang dibuka (home)
// ---------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hilangkan label "DEBUG"
      title: 'Wisata Wireframe', // judul aplikasi
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // latar semua screen putih
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // screen pertama yang tampil
    );
  }
}

// =====================================================================
//  MODEL DATA
// =====================================================================

// ---------------------------------------------------------------------
//  Class Place: cetakan data satu tempat wisata
// ---------------------------------------------------------------------
class Place {
  final String name; // nama tempat
  final String location; // lokasi tempat
  final String description; // deskripsi singkat
  final String imageAsset; // path gambar di folder assets
  bool isFavorite; // status favorit (bisa berubah, jadi tidak final)

  Place({
    required this.name,
    required this.location,
    required this.description,
    required this.imageAsset,
    this.isFavorite = false, // default: belum favorit
  });
}

// ---------------------------------------------------------------------
//  placeList: daftar data tempat yang ditampilkan di ResultScreen
// ---------------------------------------------------------------------
final List<Place> placeList = [
  Place(
    name: 'McWay Falls',
    location: 'Big Sur, California',
    description:
        'Air terjun setinggi 24 meter yang jatuh langsung ke pantai. '
        'Bisa dinikmati dari jalur pendek Overlook Trail.',
    imageAsset: 'assets/images/mcway.jpg', // gambar tempat 1
  ),
  Place(
    name: 'Bixby Bridge',
    location: 'Big Sur, California',
    description:
        'Jembatan lengkung beton ikonik di jalur Pacific Coast Highway.',
    imageAsset: 'assets/images/bixby.jpg', // gambar tempat 2
  ),
  Place(
    name: 'Pfeiffer Beach',
    location: 'Big Sur, California',
    description: 'Pantai dengan pasir ungu dan batu karang berlubang.',
    imageAsset: 'assets/images/pfeiffer.jpg', // gambar tempat 3
  ),
];

// =====================================================================
//  WIDGET PENDUKUNG (dipakai berulang di beberapa screen)
// =====================================================================

// ---------------------------------------------------------------------
//  PlaceImage: kotak gambar ber-border hitam + ikon hati di pojok
//  - Kalau imageAsset ada  -> tampilkan gambar (Image.asset)
//  - Kalau gambar gagal dimuat / kosong -> tampilkan kotak silang (X)
// ---------------------------------------------------------------------
class PlaceImage extends StatelessWidget {
  final double height; // tinggi kotak gambar
  final String? imageAsset; // path gambar (boleh null)
  final bool isFavorite; // menentukan ikon hati penuh/kosong
  final VoidCallback? onFavoriteTap; // fungsi saat hati ditekan

  const PlaceImage({
    super.key,
    required this.height,
    this.imageAsset,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity, // lebar penuh mengikuti parent
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2), // garis tepi
      ),
      child: Stack(
        // Stack = menumpuk widget (gambar di bawah, hati di atas)
        children: [
          Positioned.fill(
            child: imageAsset != null
                ? Image.asset(
                    imageAsset!, // ambil gambar dari folder assets
                    fit: BoxFit.cover, // gambar memenuhi kotak
                    // kalau file tidak ditemukan, tampilkan kotak silang
                    errorBuilder: (context, error, stackTrace) =>
                        CustomPaint(painter: CrossPainter()),
                  )
                : CustomPaint(painter: CrossPainter()), // tanpa gambar
          ),
          Positioned(
            top: 4, // jarak dari atas
            left: 4, // jarak dari kiri
            child: InkWell(
              onTap: onFavoriteTap, // jalankan fungsi favorit
              child: Container(
                padding: const EdgeInsets.all(2),
                color: Colors.white, // latar putih agar hati terlihat
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
//  CrossPainter: menggambar garis silang (X) seperti di sketsa
//  dipakai sebagai placeholder kalau gambar tidak ada
// ---------------------------------------------------------------------
class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // warna garis
      ..strokeWidth = 1.5; // ketebalan garis
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint); // kiri-atas ke kanan-bawah
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint); // kanan-atas ke kiri-bawah
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // tidak perlu digambar ulang
}

// ---------------------------------------------------------------------
//  TextLines: garis-garis abu sebagai pengganti paragraf (gaya wireframe)
// ---------------------------------------------------------------------
class TextLines extends StatelessWidget {
  final int count; // jumlah garis
  const TextLines({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (i) {
        // membuat garis sebanyak count
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4), // jarak antar garis
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: i == count - 1 ? 0.7 : 1.0, // garis terakhir lebih pendek
            child: Container(height: 2, color: Colors.black54),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------
//  TopBar: baris atas berisi avatar (kiri) dan ikon menu (kanan)
// ---------------------------------------------------------------------
class TopBar extends StatelessWidget {
  final bool showMenu; // tampilkan ikon menu atau tidak
  const TopBar({super.key, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // kiri & kanan berjauhan
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Icon(Icons.account_circle_outlined,
              size: 36, color: Colors.black), // ikon profil
        ),
        if (showMenu) // hanya muncul jika showMenu = true
          IconButton(
            onPressed: () {}, // belum ada aksi
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
//  SearchBox: kolom pencarian dengan ikon kaca pembesar
// ---------------------------------------------------------------------
class SearchBox extends StatelessWidget {
  final VoidCallback? onSubmit; // fungsi saat user menekan Enter
  const SearchBox({super.key, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (_) => onSubmit?.call(), // Enter -> jalankan onSubmit
      decoration: const InputDecoration(
        hintText: 'Search', // teks petunjuk
        prefixIcon: Icon(Icons.search, color: Colors.black), // ikon di kiri
        isDense: true, // kolom lebih ramping
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // sudut kotak (tidak bulat)
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
//  BottomNav: navigasi bawah (Search, Favorites, Filters)
// ---------------------------------------------------------------------
class BottomNav extends StatelessWidget {
  final int currentIndex; // tab yang sedang aktif
  const BottomNav({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 1.5)), // garis atas
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        elevation: 0, // tanpa bayangan
        selectedItemColor: Colors.black, // warna tab aktif
        unselectedItemColor: Colors.black54, // warna tab tidak aktif
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Filters'),
        ],
      ),
    );
  }
}

// =====================================================================
//  SCREEN 1 - HOME
//  Isi: TopBar, sapaan, kolom Search, tombol Explore, BottomNav
//  Alur: Enter di Search / tekan Explore -> pindah ke ResultScreen
// =====================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // fungsi untuk berpindah ke ResultScreen
    void goToResult() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    }

    return Scaffold(
      body: SafeArea(
        // SafeArea = konten tidak tertutup notch / status bar
        child: Padding(
          padding: const EdgeInsets.all(20), // jarak tepi 20 di semua sisi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
            children: [
              const TopBar(), // avatar + menu
              const SizedBox(height: 24), // jarak vertikal
              const Text(
                'Hi Tomas,\nwhat would you like\nto do next?', // \n = baris baru
                style: TextStyle(fontSize: 22, height: 1.3),
              ),
              const SizedBox(height: 16),
              SearchBox(onSubmit: goToResult), // Enter -> ResultScreen
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight, // tombol di kanan
                child: TextButton(
                  onPressed: goToResult, // tekan -> ResultScreen
                  child: const Text('Explore →',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}

// =====================================================================
//  SCREEN 2 - SEARCH RESULT
//  Isi: TopBar, Search, jumlah hasil, ListView kartu tempat, BottomNav
//  StatefulWidget karena ikon favorit bisa berubah (pakai setState)
//  Alur: tap kartu -> DetailScreen; tap hati -> ubah status favorit
// =====================================================================
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // kiri, atas, kanan, bawah
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 12),
              const SearchBox(),
              const SizedBox(height: 4),
              Text('${placeList.length} results', // jumlah data otomatis
                  style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 8),
              Expanded(
                // Expanded = ListView mengisi sisa ruang layar
                child: ListView.builder(
                  itemCount: placeList.length, // jumlah item = jumlah data
                  itemBuilder: (context, index) {
                    final place = placeList[index]; // ambil data ke-index
                    return InkWell(
                      // InkWell = membuat kartu bisa ditekan
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(place: place), // kirim data ke Detail
                          ),
                        ).then((_) => setState(() {})); // refresh saat kembali
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20), // jarak antar kartu
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PlaceImage(
                              height: 110,
                              imageAsset: place.imageAsset, // gambar tempat
                              isFavorite: place.isFavorite,
                              onFavoriteTap: () => setState(() {
                                place.isFavorite = !place.isFavorite; // toggle favorit
                              }),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 20), // ikon lokasi
                                const SizedBox(width: 4),
                                Expanded(
                                  // Expanded agar teks panjang turun baris
                                  child: Text(
                                    '${place.name}, ${place.location}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const TextLines(count: 4), // garis pengganti teks
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}

// =====================================================================
//  SCREEN 3 - DETAIL
//  Menerima data 'place' dari ResultScreen lewat constructor
//  Isi: tombol kembali, lokasi, gambar besar, deskripsi,
//       tombol Get Directions & Share
//  Alur: tombol kembali -> Navigator.pop -> balik ke ResultScreen
// =====================================================================
class DetailScreen extends StatefulWidget {
  final Place place; // data tempat yang dipilih
  const DetailScreen({super.key, required this.place});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final place = widget.place; // akses data dari widget induk
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), // kembali ke screen sebelumnya
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const Spacer(), // dorong avatar ke kanan
                  const TopBar(showMenu: false), // avatar saja tanpa menu
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 22),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${place.name}, ${place.location}', // nama + lokasi
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PlaceImage(
                height: 220, // gambar lebih besar dari di list
                imageAsset: place.imageAsset,
                isFavorite: place.isFavorite,
                onFavoriteTap: () => setState(() {
                  place.isFavorite = !place.isFavorite; // toggle favorit
                }),
              ),
              const SizedBox(height: 16),
              Text(place.description, // deskripsi tempat
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              const TextLines(count: 3),
              const Spacer(), // dorong tombol ke bagian bawah layar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // kiri & kanan
                children: [
                  TextButton.icon(
                    onPressed: () {}, // belum ada aksi
                    icon: const Icon(Icons.directions, color: Colors.black),
                    label: const Text('Get Directions',
                        style: TextStyle(color: Colors.black)),
                  ),
                  TextButton.icon(
                    onPressed: () {}, // belum ada aksi
                    icon: const Icon(Icons.share_outlined,
                        color: Colors.black),
                    label: const Text('Share',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
