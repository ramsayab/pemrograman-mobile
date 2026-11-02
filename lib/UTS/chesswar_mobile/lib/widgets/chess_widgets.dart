import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChessBoardView extends StatelessWidget {
  final double size;
  final Map<int, String>? pieces; // index 0..63 -> piece symbol (e.g. 'P', 'k', etc.)
  final List<int>? moveDots; // square indices with golden dots
  final List<int>? captureRings; // square indices with golden rings
  final int? selectedSquare;
  final ValueChanged<int>? onSquareTap;

  const ChessBoardView({
    super.key,
    required this.size,
    this.pieces,
    this.moveDots,
    this.captureRings,
    this.selectedSquare,
    this.onSquareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inkDark.withValues(alpha: 0.6), width: 1.5),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final row = index ~/ 8;
          final col = index % 8;
          final isLight = (row + col) % 2 == 0;
          final isSelected = selectedSquare == index;
          final hasMoveDot = moveDots?.contains(index) ?? false;
          final hasCaptureRing = captureRings?.contains(index) ?? false;
          final piece = pieces?[index];

          return GestureDetector(
            onTap: () => onSquareTap?.call(index),
            child: Container(
              color: isLight ? AppColors.boardLight : AppColors.boardDark,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Selected square highlight
                  if (isSelected)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                    ),

                  // Move dot (golden filled circle)
                  if (hasMoveDot && piece == null)
                    Container(
                      width: size / 8 * 0.28,
                      height: size / 8 * 0.28,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),

                  // Capture ring (golden ring indicator around piece)
                  if (hasCaptureRing || (hasMoveDot && piece != null))
                    Container(
                      width: size / 8 * 0.72,
                      height: size / 8 * 0.72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 2.5),
                      ),
                    ),

                  // Piece glyph
                  if (piece != null)
                    _ChessPieceGlyph(
                      piece: piece,
                      squareSize: size / 8,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChessPieceGlyph extends StatelessWidget {
  final String piece;
  final double squareSize;

  const _ChessPieceGlyph({required this.piece, required this.squareSize});

  @override
  Widget build(BuildContext context) {
    // Upper case = White, Lower case = Black
    final isWhite = piece == piece.toUpperCase();
    String symbol;
    switch (piece.toUpperCase()) {
      case 'K':
        symbol = isWhite ? '♔' : '♚';
        break;
      case 'Q':
        symbol = isWhite ? '♕' : '♛';
        break;
      case 'R':
        symbol = isWhite ? '♖' : '♜';
        break;
      case 'B':
        symbol = isWhite ? '♗' : '♝';
        break;
      case 'N':
        symbol = isWhite ? '♘' : '♞';
        break;
      case 'P':
        symbol = isWhite ? '♙' : '♟';
        break;
      default:
        symbol = piece;
    }

    return Text(
      symbol,
      style: TextStyle(
        fontSize: squareSize * 0.72,
        height: 1.0,
        color: isWhite ? const Color(0xFFFBFDFF) : const Color(0xFF1B2333),
        shadows: isWhite
            ? [
                const Shadow(
                  color: Color(0xFF1B2333),
                  blurRadius: 2,
                  offset: Offset(0.5, 0.5),
                ),
              ]
            : [
                const Shadow(
                  color: Colors.white70,
                  blurRadius: 1,
                  offset: Offset(0.5, 0.5),
                ),
              ],
      ),
    );
  }
}

class MiniPowerBoardPreview extends StatelessWidget {
  final double size;

  const MiniPowerBoardPreview({super.key, this.size = 130});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inkDark.withValues(alpha: 0.5), width: 1.2),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          final row = index ~/ 5;
          final col = index % 5;
          final isLight = (row + col) % 2 == 0;
          final isCenter = index == 12; // center king
          // Surrounding 8 squares have dots: rows 1..3, cols 1..3 except center
          final isSurrounding = (row >= 1 && row <= 3 && col >= 1 && col <= 3) && !isCenter;

          return Container(
            color: isLight ? AppColors.boardLight : AppColors.boardDark,
            child: Center(
              child: isCenter
                  ? Text(
                      '♚',
                      style: TextStyle(
                        fontSize: size / 5 * 0.75,
                        color: AppColors.inkDark,
                      ),
                    )
                  : isSurrounding
                      ? Container(
                          width: size / 5 * 0.28,
                          height: size / 5 * 0.28,
                          decoration: const BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
          );
        },
      ),
    );
  }
}
