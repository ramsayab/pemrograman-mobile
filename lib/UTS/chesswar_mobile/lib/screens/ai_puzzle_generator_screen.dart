import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/chess_widgets.dart';

class AiPuzzleGeneratorScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AiPuzzleGeneratorScreen({super.key, required this.onBack});

  @override
  State<AiPuzzleGeneratorScreen> createState() =>
      _AiPuzzleGeneratorScreenState();
}

class _AiPuzzleGeneratorScreenState extends State<AiPuzzleGeneratorScreen> {
  String difficulty = 'Medium';
  int stepLimit = 2;
  bool isGenerating = false;
  bool showPreview = true;
  bool check1 = true;
  bool check2 = true;
  bool check3 = true;

  // Board pieces setup for preview matching mockup 3
  final Map<int, String> puzzlePieces = {
    0: 'r', // Black rook a8
    6: 'k', // Black king g8
    13: 'p', // Black pawn f7
    14: 'p', // Black pawn g7
    15: 'p', // Black pawn h7
    59: 'Q', // White queen d1
    62: 'K', // White king g1
    55: 'P', // White pawn h2
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: 'AI Puzzle Generator',
          onBack: widget.onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // Difficulty selector
              const FormLabel(text: 'TINGKAT KESULITAN'),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: difficulty,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.inkDark),
                    items: ['Easy', 'Medium', 'Hard']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.inkDark,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => difficulty = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 6),
              // Step limit stepper
              const FormLabel(text: 'BATAS LANGKAH'),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$stepLimit',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkDark,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (stepLimit > 1) {
                              setState(() => stepLimit--);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Text('-',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.inkDark)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () {
                            if (stepLimit < 10) {
                              setState(() => stepLimit++);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: const Text('+',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.inkDark)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              // AI GENERATE PUZZLE button
              PrimaryButton(
                label: isGenerating ? 'GENERATING...' : 'AI GENERATE PUZZLE',
                onPressed: () {
                  setState(() => isGenerating = true);
                  final messenger = ScaffoldMessenger.of(context);
                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (!mounted) return;
                    setState(() {
                      isGenerating = false;
                      showPreview = true;
                    });
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('Puzzle AI berhasil dibuat!')),
                    );
                  });
                },
              ),

              const SizedBox(height: 18),
              // Preview Card
              if (showPreview)
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
                      const Text(
                        'HASIL (PRATINJAU)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.muted,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ChessBoardView(
                          size: 190,
                          pieces: puzzlePieces,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Validation checks
                      _ValidationCheckbox(
                        label: 'JSON valid, field fen dan solution ada',
                        value: check1,
                        onChanged: (v) => setState(() => check1 = v ?? false),
                      ),
                      _ValidationCheckbox(
                        label: 'FEN legal (python-chess)',
                        value: check2,
                        onChanged: (v) => setState(() => check2 = v ?? false),
                      ),
                      _ValidationCheckbox(
                        label: 'Setiap langkah solusi legal',
                        value: check3,
                        onChanged: (v) => setState(() => check3 = v ?? false),
                      ),

                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'SIMPAN',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Puzzle disimpan ke database!')),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlineButton(
                              label: 'BUANG',
                              onPressed: () {
                                setState(() => showPreview = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Pratinjau dibuang')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 14),
              // Dotted instructions card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.line,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Text(
                  'Bila Gemini gagal (kuota habis / kunci belum diatur), pesan instruksi tampil di sini.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
                    height: 1.4,
                  ),
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

class _ValidationCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ValidationCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.inkDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
