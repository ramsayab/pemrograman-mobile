import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  const RingkasanCard({super.key, required this.db, required this.target});
  final DbHelper db;
  final double target;
  @override
  Widget build(BuildContext context) {
    final balance = db.sum(KegiatanType.income) - db.sum(KegiatanType.expense);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xff126782),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saldo tercatat', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 5),
          Text(
            formatMoney(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  'Pemasukan',
                  db.sum(KegiatanType.income),
                  Icons.arrow_downward,
                ),
              ),
              Expanded(
                child: _Stat(
                  'Pengeluaran',
                  db.sum(KegiatanType.expense),
                  Icons.arrow_upward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Target tabungan harian: ${formatMoney(target)}',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (balance / target).clamp(0, 1),
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
          if (balance < 0)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Peringatan: pengeluaran melebihi pemasukan.',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.icon);
  final String label;
  final double value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: Colors.white70, size: 18),
      const SizedBox(width: 7),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            formatMoney(value),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}
