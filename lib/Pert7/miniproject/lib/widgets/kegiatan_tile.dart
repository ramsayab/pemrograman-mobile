import 'package:flutter/material.dart';

import '../models/kegiatan.dart';
import '../utils/format.dart';

class KegiatanTile extends StatelessWidget {
  const KegiatanTile({
    super.key,
    required this.item,
    required this.onToggle,
    this.onDelete,
    this.onEdit,
  });
  final Kegiatan item;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    elevation: 0,
    child: ListTile(
      onTap: onToggle,
      leading: Checkbox(value: item.done, onChanged: (_) => onToggle()),
      title: Text(
        item.title,
        style: TextStyle(
          decoration: item.done ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('${item.category}  |  ${formatDate(item.date)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.type != KegiatanType.none)
            Text(
              '${item.type == KegiatanType.income ? '+' : '-'} ${formatMoney(item.amount)}',
              style: TextStyle(
                color: item.type == KegiatanType.income
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (onEdit != null)
            IconButton(
              tooltip: 'Ubah',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Hapus',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
    ),
  );
}
