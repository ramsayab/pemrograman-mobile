import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const AplikasiPengeluaran());

class AplikasiPengeluaran extends StatefulWidget {
  const AplikasiPengeluaran({super.key});

  @override
  State<AplikasiPengeluaran> createState() => _AplikasiPengeluaranState();
}

class _AplikasiPengeluaranState extends State<AplikasiPengeluaran> {
  bool _modeGelap = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(() => _modeGelap = prefs.getBool('modeGelap') ?? false);
      }
    });
  }

  Future<void> _ubahTema(bool gelap) async {
    setState(() => _modeGelap = gelap);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', gelap);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pencatat Pengeluaran',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        darkTheme: ThemeData(
            colorSchemeSeed: Colors.teal,
            brightness: Brightness.dark,
            useMaterial3: true),
        themeMode: _modeGelap ? ThemeMode.dark : ThemeMode.light,
        home:
            HalamanPengeluaran(modeGelap: _modeGelap, onTemaChanged: _ubahTema),
      );
}

const kategoriPengeluaran = [
  'Makanan',
  'Transportasi',
  'Belanja',
  'Tagihan',
  'Kesehatan',
  'Hiburan',
  'Lainnya'
];

class Pengeluaran {
  const Pengeluaran(
      {this.id,
      required this.nama,
      required this.jumlah,
      required this.kategori,
      required this.tanggal});
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  Map<String, Object?> toMap() => {
        'nama': nama,
        'jumlah': jumlah,
        'kategori': kategori,
        'tanggal': tanggal
      };
  factory Pengeluaran.fromMap(Map<String, Object?> map) => Pengeluaran(
        id: map['id'] as int,
        nama: map['nama'] as String,
        jumlah: map['jumlah'] as int,
        kategori: map['kategori'] as String,
        tanggal: map['tanggal'] as String,
      );
}

class DatabasePengeluaran {
  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    final path = p.join(await getDatabasesPath(), 'pengeluaran.db');
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE pengeluaran(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        jumlah INTEGER NOT NULL,
        kategori TEXT NOT NULL,
        tanggal TEXT NOT NULL
      )''');
    });
    return _database!;
  }

  static Future<List<Pengeluaran>> semua() async {
    final rows = await (await database)
        .query('pengeluaran', orderBy: 'tanggal DESC, id DESC');
    return rows.map(Pengeluaran.fromMap).toList();
  }

  static Future<int> total() async {
    final rows = await (await database)
        .rawQuery('SELECT SUM(jumlah) AS total FROM pengeluaran');
    return (rows.first['total'] as int?) ?? 0;
  }

  static Future<void> simpan(Pengeluaran item) async {
    final db = await database;
    if (item.id == null) {
      await db.insert('pengeluaran', item.toMap());
    } else {
      await db.update('pengeluaran', item.toMap(),
          where: 'id = ?', whereArgs: [item.id]);
    }
  }

  static Future<void> hapus(int id) async =>
      (await database).delete('pengeluaran', where: 'id = ?', whereArgs: [id]);
}

class HalamanPengeluaran extends StatefulWidget {
  const HalamanPengeluaran(
      {super.key, required this.modeGelap, required this.onTemaChanged});
  final bool modeGelap;
  final ValueChanged<bool> onTemaChanged;

  @override
  State<HalamanPengeluaran> createState() => _HalamanPengeluaranState();
}

class _HalamanPengeluaranState extends State<HalamanPengeluaran> {
  late Future<List<Pengeluaran>> _data;
  late Future<int> _total;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() {
    _data = DatabasePengeluaran.semua();
    _total = DatabasePengeluaran.total();
  }

  Future<void> _tambahUbah([Pengeluaran? item]) async {
    final tersimpan = await Navigator.push<bool>(context,
        MaterialPageRoute(builder: (_) => FormPengeluaran(item: item)));
    if (tersimpan == true && mounted) setState(_muat);
  }

  String _rupiah(int nilai) =>
      'Rp ${nilai.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Pengeluaran Saya'),
          actions: [
            const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Center(child: Text('Gelap'))),
            Switch(value: widget.modeGelap, onChanged: widget.onTemaChanged),
          ],
        ),
        body: Column(children: [
          FutureBuilder<int>(
              future: _total,
              builder: (context, snapshot) => Card(
                    margin: const EdgeInsets.all(16),
                    child: ListTile(
                      leading:
                          const Icon(Icons.account_balance_wallet_outlined),
                      title: const Text('Total pengeluaran'),
                      subtitle: Text(snapshot.hasData
                          ? _rupiah(snapshot.data!)
                          : 'Menghitung...'),
                    ),
                  )),
          Expanded(
              child: FutureBuilder<List<Pengeluaran>>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Gagal memuat: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snapshot.data!;
              if (items.isEmpty) {
                return const Center(
                    child:
                        Text('Belum ada pengeluaran. Tekan + untuk menambah.'));
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading:
                        const CircleAvatar(child: Icon(Icons.receipt_long)),
                    title: Text(item.nama),
                    subtitle: Text('${item.kategori} • ${item.tanggal}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(_rupiah(item.jumlah)),
                      PopupMenuButton<String>(
                        onSelected: (aksi) async {
                          if (aksi == 'ubah') {
                            _tambahUbah(item);
                          } else {
                            final yakin = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus pengeluaran?'),
                                      content: Text(
                                          'Catatan "${item.nama}" akan dihapus.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Batal')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('Hapus')),
                                      ],
                                    ));
                            if (yakin == true) {
                              await DatabasePengeluaran.hapus(item.id!);
                              if (mounted) setState(_muat);
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'ubah', child: Text('Ubah')),
                          PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                        ],
                      ),
                    ]),
                  );
                },
              );
            },
          )),
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _tambahUbah(), child: const Icon(Icons.add)),
      );
}

class FormPengeluaran extends StatefulWidget {
  const FormPengeluaran({super.key, this.item});
  final Pengeluaran? item;

  @override
  State<FormPengeluaran> createState() => _FormPengeluaranState();
}

class _FormPengeluaranState extends State<FormPengeluaran> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _jumlah;
  late String _kategori;
  late DateTime _tanggal;

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.item?.nama ?? '');
    _jumlah = TextEditingController(text: widget.item?.jumlah.toString() ?? '');
    _kategori = widget.item?.kategori ?? kategoriPengeluaran.first;
    _tanggal = DateTime.tryParse(widget.item?.tanggal ?? '') ?? DateTime.now();
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  String get _tanggalText =>
      '${_tanggal.year.toString().padLeft(4, '0')}-${_tanggal.month.toString().padLeft(2, '0')}-${_tanggal.day.toString().padLeft(2, '0')}';

  Future<void> _pilihTanggal() async {
    final pilihan = await showDatePicker(
        context: context,
        initialDate: _tanggal,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pilihan != null) setState(() => _tanggal = pilihan);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    await DatabasePengeluaran.simpan(Pengeluaran(
      id: widget.item?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategori,
      tanggal: _tanggalText,
    ));
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(widget.item == null
                ? 'Tambah Pengeluaran'
                : 'Ubah Pengeluaran')),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              TextFormField(
                controller: _nama,
                decoration: const InputDecoration(
                    labelText: 'Nama pengeluaran',
                    border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlah,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Jumlah (rupiah)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder()),
                validator: (value) {
                  final angka = int.tryParse(value?.trim() ?? '');
                  if (angka == null) return 'Jumlah harus berupa angka bulat';
                  if (angka <= 0) return 'Jumlah harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                    labelText: 'Kategori', border: OutlineInputBorder()),
                items: kategoriPengeluaran
                    .map((kategori) => DropdownMenuItem(
                        value: kategori, child: Text(kategori)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _kategori = value);
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                  onPressed: _pilihTanggal,
                  icon: const Icon(Icons.calendar_today),
                  label: Text('Tanggal: $_tanggalText')),
              const SizedBox(height: 20),
              FilledButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan')),
            ])),
      );
}
