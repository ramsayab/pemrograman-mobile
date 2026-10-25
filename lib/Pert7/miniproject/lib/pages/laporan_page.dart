import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key, required this.db, required this.target});
  final DbHelper db;
  final double target;
  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  DateTime selected = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final daily = widget.db.kegiatan
        .where((item) => sameDay(item.date, selected))
        .toList();
    final lastSeven = widget.db.kegiatan
        .where(
          (item) =>
              !item.date.isBefore(
                DateTime(
                  selected.year,
                  selected.month,
                  selected.day,
                ).subtract(const Duration(days: 6)),
              ) &&
              !item.date.isAfter(selected),
        )
        .toList();
    final categories = <String, int>{};
    for (final item in daily.where(
      (item) => item.type == KegiatanType.expense,
    )) {
      categories[item.category] = (categories[item.category] ?? 0) + 1;
    }
    final income = daily
        .where((item) => item.type == KegiatanType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
    final expense = daily
        .where((item) => item.type == KegiatanType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: const Text('Laporan')),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanggal laporan'),
                subtitle: Text(formatLongDate(selected)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                      initialDate: selected,
                    );
                    if (picked != null) setState(() => selected = picked);
                  },
                ),
              ),
              _Value('Jumlah kegiatan', '${daily.length}', Icons.checklist),
              _Value('Pemasukan', formatMoney(income), Icons.trending_up),
              _Value('Pengeluaran', formatMoney(expense), Icons.trending_down),
              _Value(
                'Realisasi vs target',
                '${((income - expense) / widget.target * 100).clamp(0, 100).toStringAsFixed(0)}%',
                Icons.flag_outlined,
              ),
              const SizedBox(height: 16),
              Text(
                'Pengeluaran per kategori',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              ...categories.entries.map(
                (entry) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text('${entry.value}')),
                  title: Text(entry.key),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '7 hari terakhir: ${lastSeven.length} kegiatan',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
