import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/chess_widgets.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final String puzzleTitle;
  final VoidCallback onBack;

  const PuzzleDetailScreen({
    super.key,
    required this.puzzleTitle,
    required this.onBack,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  // Board setup matching mockup 9:
  // Row 0 (rank 8): g8 has Black King (index 6)
  // Row 1 (rank 7): f7 (13), g7 (14), h7 (15) have Black Pawns
  // White Rook on e1 (index 60)
  // White King on g1 (index 62)
  // White pawns on f2 (53), g2 (54), h2 (55)
  // Golden dots on e2 (52), e3 (44), e4 (36), e5 (28), e6 (20), e7 (12), e8 (4)
  late Map<int, String> boardPieces;
  late List<int> moveDots;
  int? selectedSquare = 60; // White Rook selected
  bool hasMoved = true;

  @override
  void initState() {
    super.initState();
    _resetPuzzle();
  }

  void _resetPuzzle() {
    boardPieces = {
      6: 'k', // Black King on g8
      13: 'p', // Black Pawn on f7
      14: 'p', // Black Pawn on g7
      15: 'p', // Black Pawn on h7
      60: 'R', // White Rook on e1
      62: 'K', // White King on g1
      53: 'P', // White Pawn on f2
      54: 'P', // White Pawn on g2
      55: 'P', // White Pawn on h2
    };
    // Dots along column e (index % 8 == 4):
    moveDots = [4, 12, 20, 28, 36, 44, 52];
  }

  void _handleSquareTap(int index) {
    setState(() {
      if (index == 60) {
        selectedSquare = 60;
        moveDots = [4, 12, 20, 28, 36, 44, 52];
      } else if (index == 4 || moveDots.contains(index)) {
        // Move Rook to back rank
        boardPieces.remove(60);
        boardPieces[index] = 'R';
        selectedSquare = index;
        moveDots.clear();
        hasMoved = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: widget.puzzleTitle,
          onBack: widget.onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            children: [
              // Subtitle bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Mate in 1  |  Easy',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  Text(
                    'Putih jalan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Chessboard
              Center(
                child: ChessBoardView(
                  size: 260,
                  pieces: boardPieces,
                  moveDots: moveDots,
                  selectedSquare: selectedSquare,
                  onSquareTap: _handleSquareTap,
                ),
              ),
              const SizedBox(height: 16),

              // Success Banner
              if (hasMoved)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.inkDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Langkah benar!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Re8# - skakmat',
                        style: TextStyle(
                          color: AppColors.line,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 14),
              // Percobaan & Reward
              Row(
                children: const [
                  Expanded(
                    child: MetricCard(
                      label: 'Percobaan',
                      value: '1',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MetricCard(
                      label: 'Reward',
                      value: '+50 XP',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              // Button Kembali
              OutlineButton(
                label: 'KEMBALI KE DAFTAR',
                onPressed: widget.onBack,
              ),

              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Solusi divalidasi di server; jawaban tidak dikirim ke aplikasi.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.muted,
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
