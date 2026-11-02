import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PuzzlesScreen extends StatefulWidget {
  final ValueChanged<String> onSelectPuzzle;

  const PuzzlesScreen({
    super.key,
    required this.onSelectPuzzle,
  });

  @override
  State<PuzzlesScreen> createState() => _PuzzlesScreenState();
}

class _PuzzlesScreenState extends State<PuzzlesScreen> {
  String selectedTab = 'Easy';

  final List<Map<String, dynamic>> puzzles = [
    {
      'title': 'Back-Rank Basics',
      'mate': 'Mate in 1',
      'badge': 'SELESAI',
      'isCompleted': true,
      'attempts': 2,
    },
    {
      'title': 'Smothered Hint',
      'mate': 'Mate in 2',
      'badge': 'SELESAI',
      'isCompleted': true,
      'attempts': 2,
    },
    {
      'title': 'Rook Lift',
      'mate': 'Mate in 2',
      'badge': '+50 XP',
      'isCompleted': false,
      'attempts': 0,
    },
    {
      'title': 'Queen Sacrifice',
      'mate': 'Mate in 3',
      'badge': '+50 XP',
      'isCompleted': false,
      'attempts': 0,
    },
    {
      'title': 'Double Check',
      'mate': 'Mate in 3',
      'badge': '+50 XP',
      'isCompleted': false,
      'attempts': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MockupHeader(title: 'Latihan Puzzle'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Easy / Medium / Hard tabs
              Row(
                children: ['Easy', 'Medium', 'Hard'].map((tab) {
                  final isActive = selectedTab == tab;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () => setState(() => selectedTab = tab),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isActive ? AppColors.inkDark : AppColors.white,
                            foregroundColor:
                                isActive ? Colors.white : AppColors.inkDark,
                            elevation: 0,
                            side: BorderSide(
                              color: isActive
                                  ? AppColors.inkDark
                                  : AppColors.inkDark,
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color:
                                  isActive ? Colors.white : AppColors.inkDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              const Text(
                'Solved 7 / 18',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: puzzles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final puzzle = puzzles[index];
              final isCompleted = puzzle['isCompleted'] as bool;

              return InkWell(
                onTap: () => widget.onSelectPuzzle(puzzle['title'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Chess icon box
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '♚',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.inkDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              puzzle['title'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.inkDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              puzzle['mate'] as String,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right badge & attempts
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.inkDark
                                  : AppColors.gold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              puzzle['badge'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Percobaan: ${puzzle['attempts']}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
