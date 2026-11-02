import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AdminScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenAiPuzzleGenerator;

  const AdminScreen({
    super.key,
    required this.onBack,
    required this.onOpenAiPuzzleGenerator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: 'Panel Admin',
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // 4 Stat boxes (2x2 grid)
              const Row(
                children: [
                  Expanded(
                    child: MetricCard(label: 'Pengguna', value: '128'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MetricCard(label: 'Pertandingan', value: '540'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: MetricCard(label: 'Puzzle', value: '36'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MetricCard(label: 'Tips', value: '24'),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Menu list items
              _AdminMenuItem(
                title: 'Data Pengguna',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Data Pengguna')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'Data Pertandingan',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Data Pertandingan')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'Manajemen Puzzle',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Manajemen Puzzle')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'AI Puzzle Generator',
                isHighlighted: true,
                onTap: onOpenAiPuzzleGenerator,
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'Manajemen Tips Catur',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Manajemen Tips Catur')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'Peran & Hak Akses',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Peran & Hak Akses')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _AdminMenuItem(
                title: 'Audit Log Aktivitas',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buka Audit Log Aktivitas')),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Text(
                'Menu tampil sesuai hak akses (RBAC); endpoint /admin memverifikasi peran di server.',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final String title;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.title,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(
            color: isHighlighted ? AppColors.inkDark : AppColors.line,
            width: isHighlighted ? 1.8 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isHighlighted ? AppColors.inkDark : AppColors.muted,
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isHighlighted ? FontWeight.w800 : FontWeight.w600,
                  color: AppColors.inkDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
