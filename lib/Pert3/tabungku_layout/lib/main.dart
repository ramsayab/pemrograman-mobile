import 'package:flutter/material.dart';

void main() {
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B87)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
      ),
      home: const RingkasanPage(),
    );
  }
}

class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  static const transaksi = [
    (
      judul: 'Menabung rutin',
      tanggal: '12 November 2026',
      nominal: '+ Rp 250.000',
      ikon: Icons.savings_outlined,
      warna: Color(0xFF176B87),
    ),
    (
      judul: 'Beli buku kuliah',
      tanggal: '10 November 2026',
      nominal: '- Rp 125.000',
      ikon: Icons.shopping_bag_outlined,
      warna: Color(0xFFD05A3A),
    ),
    (
      judul: 'Menabung rutin',
      tanggal: '05 November 2026',
      nominal: '+ Rp 200.000',
      ikon: Icons.savings_outlined,
      warna: Color(0xFF176B87),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final lebarLayar = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Tabungan'),
        centerTitle: false,
        backgroundColor: tema.colorScheme.surface,
      ),
      // Body dibuat dapat digulir agar konten tetap aman pada layar pendek.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final lebarKonten = constraints.maxWidth > 760
                ? 760.0
                : constraints.maxWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: lebarLayar < 360 ? 12 : 20,
                vertical: 20,
              ),
              child: Center(
                // Container membatasi lebar isi agar proporsional di tablet.
                child: Container(
                  constraints: BoxConstraints(maxWidth: lebarKonten),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bagian pembuka memberi konteks pada ringkasan.
                      Text(
                        'Halo, Ramsay!',
                        style: tema.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pantau progres tabunganmu hari ini.',
                        style: tema.textTheme.bodyMedium?.copyWith(
                          color: tema.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Card utama menyusun nama, saldo, dan target dengan Column.
                      Card(
                        elevation: 0,
                        color: tema.colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tabungan Kuliah',
                                      style: tema.textTheme.titleLarge
                                          ?.copyWith(
                                            color: tema.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: tema.colorScheme.onPrimary,
                                    size: 28,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Saldo saat ini',
                                style: tema.textTheme.bodyMedium?.copyWith(
                                  color: tema.colorScheme.onPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp 1.250.000',
                                style: tema.textTheme.headlineMedium?.copyWith(
                                  color: tema.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Row berikut menempatkan nilai target dan persentase.
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Target: Rp 5.000.000',
                                    style: tema.textTheme.bodyMedium?.copyWith(
                                      color: tema.colorScheme.onPrimary
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                  Text(
                                    '25%',
                                    style: tema.textTheme.labelLarge?.copyWith(
                                      color: tema.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: 0.25,
                                  minHeight: 8,
                                  backgroundColor: tema.colorScheme.onPrimary
                                      .withValues(alpha: 0.2),
                                  color: tema.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tiga tombol kategori disusun dalam satu Row yang fleksibel.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _AksiRingkas(
                            ikon: Icons.add_circle_outline,
                            label: 'Menabung',
                            warna: tema.colorScheme.primary,
                          ),
                          _AksiRingkas(
                            ikon: Icons.remove_circle_outline,
                            label: 'Tarik',
                            warna: tema.colorScheme.secondary,
                          ),
                          _AksiRingkas(
                            ikon: Icons.history,
                            label: 'Riwayat',
                            warna: tema.colorScheme.tertiary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Header daftar transaksi menggunakan Row dan alignment.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Terbaru',
                            style: tema.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Lihat semua'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // ListTile menjaga judul, tanggal, dan nominal tetap rapi.
                      for (final item in transaksi)
                        Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: item.warna.withValues(
                                alpha: 0.12,
                              ),
                              foregroundColor: item.warna,
                              child: Icon(item.ikon),
                            ),
                            title: Text(
                              item.judul,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(item.tanggal),
                            trailing: Text(
                              item.nominal,
                              style: tema.textTheme.labelLarge?.copyWith(
                                color: item.warna,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AksiRingkas extends StatelessWidget {
  final IconData ikon;
  final String label;
  final Color warna;

  const _AksiRingkas({
    required this.ikon,
    required this.label,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container memberi latar dan jarak konsisten pada setiap ikon.
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(ikon, color: warna, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
