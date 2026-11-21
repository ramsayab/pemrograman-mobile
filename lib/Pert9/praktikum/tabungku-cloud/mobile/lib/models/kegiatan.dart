enum Tipe { tanpa, pemasukan, pengeluaran }

class Kegiatan {
  const Kegiatan({
    this.id,
    required this.judul,
    required this.tanggal,
    this.selesai = false,
    this.tipe = Tipe.tanpa,
    this.nominal = 0,
    this.kategori = '-',
    this.catatan,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String judul;
  final DateTime tanggal;
  final bool selesai;
  final Tipe tipe;
  final int nominal;
  final String kategori;
  final String? catatan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => {
        'judul': judul,
        'tanggal': tanggal.toIso8601String().substring(0, 10),
        'selesai': selesai,
        'tipe': tipe.name,
        'nominal': nominal,
        'kategori': kategori,
        'catatan': catatan,
      };

  factory Kegiatan.fromJson(Map<String, dynamic> json) => Kegiatan(
        id: json['id'] as int,
        judul: json['judul'] as String,
        tanggal: DateTime.parse(json['tanggal'] as String),
        selesai: json['selesai'] as bool,
        tipe: Tipe.values.byName(json['tipe'] as String),
        nominal: (json['nominal'] as num).toInt(),
        kategori: json['kategori'] as String,
        catatan: json['catatan'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );
}
