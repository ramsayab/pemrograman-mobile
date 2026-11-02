import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ArenaScreen extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onContinueToDraft;

  const ArenaScreen({
    super.key,
    required this.onContinueToDraft,
  });

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  int selectedIndex = 2; // Default to 3 Medium

  final List<Map<String, dynamic>> levels = [
    {
      'id': 1,
      'name': '1  Easy',
      'xp': 'Menang +100 XP  |  Kalah +25 XP',
    },
    {
      'id': 2,
      'name': '2  Medium-Easy',
      'xp': 'Menang +150 XP  |  Kalah +35 XP',
    },
    {
      'id': 3,
      'name': '3  Medium',
      'xp': 'Menang +200 XP  |  Kalah +50 XP',
    },
    {
      'id': 4,
      'name': '4  Hard',
      'xp': 'Menang +300 XP  |  Kalah +75 XP',
    },
    {
      'id': 5,
      'name': '5  Expert',
      'xp': 'Menang +500 XP  |  Kalah +125 XP',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MockupHeader(title: 'Arena'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              const Text(
                'Pilih tingkat bot',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inkDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Semakin tinggi, semakin banyak XP',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 16),

              // Difficulty choices
              for (int i = 0; i < levels.length; i++) ...[
                _DifficultyChoiceTile(
                  title: levels[i]['name'] as String,
                  xpText: levels[i]['xp'] as String,
                  isSelected: selectedIndex == i,
                  onTap: () => setState(() => selectedIndex = i),
                ),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 20),
              PrimaryButton(
                label: 'LANJUT KE DRAFT',
                onPressed: () {
                  widget.onContinueToDraft(levels[selectedIndex]);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _DifficultyChoiceTile extends StatelessWidget {
  final String title;
  final String xpText;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyChoiceTile({
    required this.title,
    required this.xpText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.inkDark : AppColors.line,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.inkDark : AppColors.line,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.inkDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    xpText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
