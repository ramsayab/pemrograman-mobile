import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/chess_widgets.dart';

class PowerRevealScreen extends StatelessWidget {
  final VoidCallback onStartMatch;

  const PowerRevealScreen({
    super.key,
    required this.onStartMatch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MockupHeader(title: 'Kekuatan Terpilih'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            children: [
              // Large Hero Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.inkDark, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Icon with x2 badge
                    Stack(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.inkDark, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              '♔',
                              style: TextStyle(
                                fontSize: 34,
                                color: AppColors.inkDark,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'x2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'UNDYING KING',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.inkDark,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Raja memiliki dua nyawa. Bidak lawan yang menangkap Raja dihapus dan Raja dipulihkan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mini 5x5 chessboard preview
                    const MiniPowerBoardPreview(size: 130),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.line, height: 1),
                    const SizedBox(height: 12),
                    // Stats footer inside card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tingkat bot',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.muted,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '3  Medium',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.inkDark,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              'Bot ML',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.muted,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'v1.2',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.inkDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Lima kartu lainnya tetap rahasia.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              PrimaryButton(
                label: 'MULAI BERTANDING',
                onPressed: onStartMatch,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
