class Ringkasan {
  const Ringkasan({
    required this.tanggal,
    required this.jumlahKegiatan,
    required this.selesai,
    required this.pemasukan,
    required this.pengeluaran,
    required this.tabungan,
  });

  final DateTime tanggal;
  final int jumlahKegiatan;
  final int selesai;
  final int pemasukan;
  final int pengeluaran;
  final int tabungan;

  factory Ringkasan.fromJson(Map<String, dynamic> json) => Ringkasan(
        tanggal: DateTime.parse(json['tanggal'] as String),
        jumlahKegiatan: (json['jumlah_kegiatan'] as num).toInt(),
        selesai: (json['selesai'] as num).toInt(),
        pemasukan: (json['pemasukan'] as num).toInt(),
        pengeluaran: (json['pengeluaran'] as num).toInt(),
        tabungan: (json['tabungan'] as num).toInt(),
      );
}

class TotalKategori {
  const TotalKategori({required this.kategori, required this.total});

  final String kategori;
  final int total;

  factory TotalKategori.fromJson(Map<String, dynamic> json) => TotalKategori(
        kategori: json['kategori'] as String,
        total: (json['total'] as num).toInt(),
      );
}

class LaporanHarian extends Ringkasan {
  const LaporanHarian({
    required super.tanggal,
    required super.jumlahKegiatan,
    required super.selesai,
    required super.pemasukan,
    required super.pengeluaran,
    required super.tabungan,
    required this.perKategori,
  });

  final List<TotalKategori> perKategori;

  factory LaporanHarian.fromJson(Map<String, dynamic> json) {
    final ringkasan = Ringkasan.fromJson(json);
    return LaporanHarian(
      tanggal: ringkasan.tanggal,
      jumlahKegiatan: ringkasan.jumlahKegiatan,
      selesai: ringkasan.selesai,
      pemasukan: ringkasan.pemasukan,
      pengeluaran: ringkasan.pengeluaran,
      tabungan: ringkasan.tabungan,
      perKategori: (json['per_kategori'] as List<dynamic>)
          .map((item) => TotalKategori.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LaporanRentang {
  const LaporanRentang({
    required this.mulai,
    required this.sampai,
    required this.harian,
  });

  final DateTime mulai;
  final DateTime sampai;
  final List<Ringkasan> harian;

  factory LaporanRentang.fromJson(Map<String, dynamic> json) => LaporanRentang(
        mulai: DateTime.parse(json['mulai'] as String),
        sampai: DateTime.parse(json['sampai'] as String),
        harian: (json['harian'] as List<dynamic>)
            .map((item) => Ringkasan.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
}
