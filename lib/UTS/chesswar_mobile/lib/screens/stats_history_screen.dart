import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class StatsHistoryScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onResumeGame;

  const StatsHistoryScreen({
    super.key,
    required this.onBack,
    required this.onResumeGame,
  });

  @override
  State<StatsHistoryScreen> createState() => _StatsHistoryScreenState();
}

class _StatsHistoryScreenState extends State<StatsHistoryScreen> {
  bool hasSavedGame = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: 'Statistik & Riwayat',
          onBack: widget.onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // Top 2 cards: Win Rate & Avg Duration
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WIN RATE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.muted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 68,
                              height: 68,
                              child: CustomPaint(
                                painter: _DonutChartPainter(percentage: 0.20),
                                child: const Center(
                                  child: Text(
                                    '20%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.inkDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RATA-RATA DURASI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.muted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              '4,6',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.inkDark,
                                height: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Center(
                            child: Text(
                              'menit  (5 game)',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              // Card: PENGGUNAAN KEKUATAN
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'PENGGUNAAN KEKUATAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.muted,
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 12),
                    _PowerProgressBar(
                      title: 'Confused Pawn',
                      progress: 0.20,
                    ),
                    SizedBox(height: 8),
                    _PowerProgressBar(
                      title: 'Blink Knight',
                      progress: 0.85,
                    ),
                    SizedBox(height: 8),
                    _PowerProgressBar(
                      title: 'Super Rook',
                      progress: 0.45,
                    ),
                    SizedBox(height: 8),
                    _PowerProgressBar(
                      title: 'Undying King',
                      progress: 0.85,
                    ),
                    SizedBox(height: 8),
                    _PowerProgressBar(
                      title: 'Omni Queen',
                      progress: 0.85,
                    ),
                    SizedBox(height: 8),
                    _PowerProgressBar(
                      title: 'Grey Bishop',
                      progress: 0.85,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              // Section: Riwayat Pertandingan
              const Text(
                'Riwayat Pertandingan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkDark,
                ),
              ),
              const SizedBox(height: 10),
              _MatchHistoryItem(
                isWin: false,
                title: 'Omni Queen  Lv.3',
                subtitle: 'Hari ini',
                duration: '13m 10s',
              ),
              const SizedBox(height: 8),
              _MatchHistoryItem(
                isWin: true,
                title: 'Undying King  Lv.3',
                subtitle: 'Hari ini',
                duration: '5m 01s',
              ),
              const SizedBox(height: 8),
              _MatchHistoryItem(
                isWin: true,
                title: 'Blink Knight  Lv.2',
                subtitle: 'Hari ini',
                duration: '4m 20s',
              ),

              const SizedBox(height: 16),
              // Card: Game tersimpan
              if (hasSavedGame)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Game tersimpan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.inkDark,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Undying King  |  Lv.3',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: widget.onResumeGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.inkDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: const Size(60, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('RESUME',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          setState(() => hasSavedGame = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Game tersimpan dibuang')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.inkDark,
                          side: const BorderSide(color: AppColors.inkDark),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          minimumSize: const Size(54, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('BUANG',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
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

class _DonutChartPainter extends CustomPainter {
  final double percentage;

  _DonutChartPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 9.0;

    // Background track
    final bgPaint = Paint()
      ..color = AppColors.line
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Active arc
    final activePaint = Paint()
      ..color = AppColors.inkDark
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PowerProgressBar extends StatelessWidget {
  final String title;
  final double progress;

  const _PowerProgressBar({
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.inkDark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: AppColors.line,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  color: AppColors.inkDark,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchHistoryItem extends StatelessWidget {
  final bool isWin;
  final String title;
  final String subtitle;
  final String duration;

  const _MatchHistoryItem({
    required this.isWin,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
    );
  }
}
