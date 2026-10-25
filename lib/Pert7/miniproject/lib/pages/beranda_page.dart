import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';
import '../widgets/kegiatan_tile.dart';
import '../widgets/ringkasan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({
    super.key,
    required this.db,
    required this.target,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });
  final DbHelper db;
  final double target;
  final ValueChanged<Kegiatan> onToggle;
  final ValueChanged<Kegiatan> onDelete;
  final ValueChanged<Kegiatan> onEdit;
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final matches = widget.db.kegiatan
        .where(
          (item) =>
              item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    final items = matches.where((item) => sameDay(item.date, today)).toList();
    final other = matches.where((item) => !sameDay(item.date, today)).toList();
    final done = items.where((item) => item.done).length;
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: const Text('TabungKu')),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Hari ini, ${formatLongDate(today)}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              RingkasanCard(db: widget.db, target: widget.target),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  labelText: 'Cari kegiatan atau kategori',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktivitas hari ini',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$done/${items.length} selesai',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...items.map(
                (item) => KegiatanTile(
                  item: item,
                  onToggle: () => widget.onToggle(item),
                  onDelete: () => widget.onDelete(item),
                  onEdit: () => widget.onEdit(item),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Aktivitas lainnya',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...other.map(
                (item) => KegiatanTile(
                  item: item,
                  onToggle: () => widget.onToggle(item),
                  onDelete: () => widget.onDelete(item),
                  onEdit: () => widget.onEdit(item),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
