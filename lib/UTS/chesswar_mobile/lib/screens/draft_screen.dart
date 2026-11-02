import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DraftScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<int> onRevealPower;

  const DraftScreen({
    super.key,
    required this.onBack,
    required this.onRevealPower,
  });

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  int selectedCard = 3; // 1-indexed, default 3 selected matching mockup

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: 'Draft Kekuatan',
          onBack: widget.onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              const Center(
                child: Text(
                  'PILIH 1 KARTU KEKUATAN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inkDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Kekuatan diundi acak oleh sistem. Bot tetap bermain standar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2x3 Grid of mystery cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final cardNum = index + 1;
                  final isSelected = selectedCard == cardNum;

                  return GestureDetector(
                    onTap: () => setState(() => selectedCard = cardNum),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        border: Border.all(
                          color: isSelected ? AppColors.gold : AppColors.line,
                          width: isSelected ? 2.5 : 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '?',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: isSelected
                                  ? AppColors.gold
                                  : AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'KARTU $cardNum',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.inkDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Kartu $selectedCard dipilih',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              PrimaryButton(
                label: 'UNGKAP KEKUATAN',
                onPressed: () => widget.onRevealPower(selectedCard),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
