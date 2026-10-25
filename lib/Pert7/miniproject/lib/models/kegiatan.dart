enum KegiatanType { none, income, expense }

class Kegiatan {
  Kegiatan({
    this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
    this.done = false,
  });

  final int? id;
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final KegiatanType type;
  bool done;

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': title,
    'tanggal': date.toIso8601String().substring(0, 10),
    'selesai': done ? 1 : 0,
    'tipe': type == KegiatanType.none
        ? 'tanpa'
        : type == KegiatanType.income
        ? 'pemasukan'
        : 'pengeluaran',
    'nominal': amount.round(),
    'kategori': type == KegiatanType.expense ? category : '-',
  };

  factory Kegiatan.fromMap(Map<String, Object?> map) => Kegiatan(
    id: map['id'] as int?,
    title: map['judul'] as String,
    category: map['kategori'] as String? ?? '-',
    date: DateTime.parse(map['tanggal'] as String),
    amount: (map['nominal'] as num).toDouble(),
    type: switch (map['tipe'] as String) {
      'pemasukan' || 'income' => KegiatanType.income,
      'pengeluaran' || 'expense' => KegiatanType.expense,
      _ => KegiatanType.none,
    },
    done: map['selesai'] == 1,
  );
}
