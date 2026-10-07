import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}

// LATIHAN 2: tambah properti deskripsi pada class Makanan
class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;
  const Makanan(this.nama, this.harga, this.deskripsi);
}

// LATIHAN 1: tambah 3 menu baru (Soto Ayam, Bakso, Es Jeruk)
const daftarMenu = [
  Makanan('Nasi Goreng', 15000, 'Nasi goreng dengan telur dan ayam suwir.'),
  Makanan('Mie Ayam', 12000, 'Mie dengan topping ayam dan pangsit.'),
  Makanan('Es Teh', 4000, 'Teh manis dingin yang menyegarkan.'),
  Makanan('Ayam Bakar', 20000, 'Ayam bakar bumbu kecap dengan sambal.'),
  Makanan('Soto Ayam', 14000, 'Soto kuah kuning dengan suwiran ayam.'),
  Makanan('Bakso', 13000, 'Bakso sapi dengan kuah kaldu hangat.'),
  Makanan('Es Jeruk', 5000, 'Jeruk peras segar dengan es batu.'),
];

// LATIHAN 4: format ribuan buatan sendiri (15000 -> Rp 15.000)
String formatRupiah(int angka) {
  final hasil = angka.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return 'Rp $hasil';
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Menu')),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          // LATIHAN 3: Card diganti Container (warna latar + sudut membulat)
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(item.nama),
              subtitle: Text(formatRupiah(item.harga)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(makanan: item)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Makanan makanan;
  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80),
            const SizedBox(height: 16),
            Text(makanan.nama, style: const TextStyle(fontSize: 24)),
            Text(formatRupiah(makanan.harga)),
            const SizedBox(height: 12),
            // LATIHAN 2: tampilkan deskripsi di bawah harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(makanan.deskripsi, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
