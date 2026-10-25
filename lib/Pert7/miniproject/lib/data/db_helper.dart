import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';

class DbHelper {
  DbHelper()
    : _items = [
        Kegiatan(
          title: 'Kirim laporan praktikum',
          category: 'Kuliah',
          date: DateTime(2026, 10, 25),
          amount: 0,
          type: KegiatanType.none,
        ),
        Kegiatan(
          title: 'Makan siang',
          category: 'Harian',
          date: DateTime(2026, 10, 25),
          amount: 28000,
          type: KegiatanType.expense,
          done: true,
        ),
        Kegiatan(
          title: 'Honor desain poster',
          category: 'Kerja paruh waktu',
          date: DateTime(2026, 10, 24),
          amount: 250000,
          type: KegiatanType.income,
          done: true,
        ),
      ];

  final List<Kegiatan> _items;
  Database? _database;
  List<Kegiatan> get kegiatan => List.unmodifiable(_items);

  Future<Database> get database async => _database ??= await openDatabase(
    join(await getDatabasesPath(), 'tabungku.db'),
    version: 1,
    onCreate: (db, version) => db.execute(
      '''CREATE TABLE kegiatan(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT NOT NULL, tanggal TEXT NOT NULL, selesai INTEGER NOT NULL DEFAULT 0, tipe TEXT NOT NULL, nominal INTEGER NOT NULL DEFAULT 0, kategori TEXT NOT NULL)''',
    ),
  );

  Future<void> init() async {
    final rows = await (await database).query(
      'kegiatan',
      orderBy: 'tanggal DESC, id DESC',
    );
    if (rows.isNotEmpty) {
      _items
        ..clear()
        ..addAll(rows.map(Kegiatan.fromMap));
    } else {
      for (final item in _items) {
        await (await database).insert('kegiatan', item.toMap());
      }
    }
  }

  void insert(Kegiatan item) {
    _items.insert(0, item);
    database.then((db) => db.insert('kegiatan', item.toMap()));
  }

  void update(Kegiatan item) {
    final index = _items.indexWhere((old) => old.id == item.id);
    if (index >= 0) _items[index] = item;
    database.then(
      (db) => db.update(
        'kegiatan',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      ),
    );
  }

  void delete(Kegiatan item) {
    _items.remove(item);
    if (item.id != null) {
      database.then(
        (db) => db.delete('kegiatan', where: 'id = ?', whereArgs: [item.id]),
      );
    }
  }

  double sum(KegiatanType type) => _items
      .where((item) => item.type == type)
      .fold(0, (sum, item) => sum + item.amount);
  Map<String, int> countByCategory() {
    final result = <String, int>{};
    for (final item in _items.where(
      (item) => item.type == KegiatanType.expense,
    )) {
      result[item.category] = (result[item.category] ?? 0) + 1;
    }
    return result;
  }
}
