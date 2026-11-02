import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onResumeGame;
  final VoidCallback onPlayNow;
  final VoidCallback onViewAllHistory;
  final VoidCallback onOpenProfile;

  const HomeScreen({
    super.key,
    required this.onResumeGame,
    required this.onPlayNow,
    required this.onViewAllHistory,
    required this.onOpenProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tipIndex = 0;
  final List<Map<String, String>> tips = [
    {
      'tip':
          'Kembangkan kudamu sebelum gajahmu. Kuda punya jangkauan lebih pendek.',
      'author': '- Opening Rules'
    },
    {
      'tip':
          'Kuasai petak pusat (e4, d4, e5, d5) sejak awal untuk mendominasi ruang gerak.',
      'author': '- Center Control'
    },
    {
      'tip':
          'Jangan gerakkan bidak yang sama dua kali di pembukaan kecuali terpaksa.',
      'author': '- Tempo Principles'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Top greeting & avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Halo, Asep',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkDark,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            InkWell(
              onTap: widget.onOpenProfile,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.inkDark, width: 1.5),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inkDark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        // Progress Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LV. 1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inkDark,
                    ),
                  ),
                  Text(
                    '825 / 1000 XP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 10,
                  color: AppColors.line,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.825,
                    child: Container(
                      color: AppColors.inkDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Peringkat kamu  #1',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: 'RESUME GAME',
                onPressed: widget.onResumeGame,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlineButton(
                label: 'MAIN SEKARANG',
                onPressed: widget.onPlayNow,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        // 3 Stat Cards with sparklines
        const Row(
          children: [
            Expanded(
              child: _SparklineStatCard(
                label: 'Win Rate',
                value: '20%',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _SparklineStatCard(
                label: 'Rata-rata',
                value: '4,6 m',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _SparklineStatCard(
                label: 'Puzzle',
                value: '7/18',
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),
        // CHESS TIP Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CHESS TIP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.muted,
                      letterSpacing: 0.6,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        tipIndex = (tipIndex + 1) % tips.length;
                      });
                    },
                    child: const Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '"${tips[tipIndex]['tip']}"',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.inkDark,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  tips[tipIndex]['author']!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        // Aktivitas Terakhir
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Aktivitas Terakhir',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkDark,
                ),
              ),
            ),
            InkWell(
              onTap: widget.onViewAllHistory,
              child: const Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Activity Row 1 (KALAH)
        _HomeActivityTile(
          isWin: false,
          opponent: 'vs Bot ML  Lv.3',
          power: 'Omni Queen',
          duration: '13m 10s',
          onTap: widget.onResumeGame,
        ),
        const SizedBox(height: 8),

        // Activity Row 2 (MENANG)
        _HomeActivityTile(
          isWin: true,
          opponent: 'vs Bot ML  Lv.3',
          power: 'Undying King',
          duration: '5m 01s',
          onTap: widget.onResumeGame,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SparklineStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _SparklineStatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.inkDark,
            ),
          ),
          const SizedBox(height: 8),
          CustomPaint(
            size: const Size(double.infinity, 16),
            painter: _SparklinePainter(),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.inkDark
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.75,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height * 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeActivityTile extends StatelessWidget {
  final bool isWin;
  final String opponent;
  final String power;
  final String duration;
  final VoidCallback onTap;

  const _HomeActivityTile({
    required this.isWin,
    required this.opponent,
    required this.power,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isWin ? AppColors.inkDark : const Color(0xFF6E788C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isWin ? 'MENANG' : 'KALAH',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opponent,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    power,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
