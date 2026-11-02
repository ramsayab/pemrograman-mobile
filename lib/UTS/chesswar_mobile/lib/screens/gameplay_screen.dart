import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/chess_widgets.dart';

class GameplayScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onGameOver;

  const GameplayScreen({
    super.key,
    required this.onBack,
    required this.onGameOver,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  bool isFlipped = false;
  int? selectedSquare = 35; // e4 pawn
  List<int> moveDots = [43, 45, 51]; // yellow dots
  List<int> captureRings = [28]; // yellow capture ring

  late Map<int, String> boardPieces;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    boardPieces = {
      // Black Pieces
      0: 'r', 1: 'n', 2: 'b', 3: 'q', 4: 'k', 5: 'b', 6: 'n', 7: 'r',
      8: 'p', 9: 'p', 10: 'p', 11: 'p', 12: 'p', 13: 'p', 14: 'p', 15: 'p',
      18: 'n', // Black knight on c6
      28: 'p', // Black pawn on e5

      // White Pieces
      35: 'p', // White pawn on d4/e4
      42: 'N', // White knight on f3
      26: 'B', // White bishop on c4
      48: 'P', 49: 'P', 50: 'P', 51: 'P', 53: 'P', 54: 'P', 55: 'P',
      56: 'R', 57: 'N', 58: 'B', 59: 'Q', 60: 'K', 62: 'B', 63: 'R',
    };
  }

  void _openMenuArena() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MenuArenaSheet(
        onSurrender: () {
          Navigator.pop(context);
          widget.onGameOver();
        },
        onFlip: () {
          Navigator.pop(context);
          setState(() => isFlipped = !isFlipped);
        },
        onUndo: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Langkah terakhir dibatalkan')),
          );
        },
        onForceMove: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bot dipaksa melangkah')),
          );
        },
        onNewGame: () {
          Navigator.pop(context);
          setState(() => _resetBoard());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Game baru dimulai')),
          );
        },
        onSaveAndExit: () {
          Navigator.pop(context);
          widget.onBack();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with more_vert icon
        MockupHeader(
          title: 'Medium (3)',
          onBack: widget.onBack,
          trailing: InkWell(
            onTap: _openMenuArena,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.more_vert, color: AppColors.inkDark),
            ),
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            children: [
              // Top Card: Undying King + Nyawa
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.inkDark),
                      ),
                      child: const Center(
                        child: Text('♔',
                            style: TextStyle(
                                fontSize: 18, color: AppColors.inkDark)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Undying King',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.inkDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Raja punya 2 nyawa',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Nyawa',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.circle,
                                size: 10, color: AppColors.inkDark),
                            SizedBox(width: 4),
                            Icon(Icons.circle,
                                size: 10, color: AppColors.inkDark),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Bot ML opponent bar
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Center(
                      child: Text(
                        'AI',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.inkDark),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Bot ML v1.2',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('♟♟♟', style: TextStyle(fontSize: 11)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '00:42',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Chessboard View
              Center(
                child: ChessBoardView(
                  size: 268,
                  pieces: boardPieces,
                  moveDots: moveDots,
                  captureRings: captureRings,
                  selectedSquare: selectedSquare,
                  onSquareTap: (index) {
                    setState(() {
                      if (selectedSquare == index) {
                        selectedSquare = null;
                        moveDots.clear();
                        captureRings.clear();
                      } else if (boardPieces.containsKey(index)) {
                        selectedSquare = index;
                        moveDots = [(index + 8) % 64, (index + 16) % 64];
                        captureRings = [(index + 7) % 64];
                      } else if (selectedSquare != null) {
                        // Move piece
                        final p = boardPieces.remove(selectedSquare!);
                        if (p != null) boardPieces[index] = p;
                        selectedSquare = null;
                        moveDots.clear();
                        captureRings.clear();
                      }
                    });
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Player (Asep) Bar
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.inkDark),
                    ),
                    child: const Center(
                      child: Text(
                        'AS',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.inkDark),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Asep',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('♙', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '00:57',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Control buttons row: [ Undo ] [ Flip ] [ Force ] [ Baru ] [ Simpan ]
              Row(
                children: [
                  _MiniControlButton(
                    label: 'Undo',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Undo langkah')),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _MiniControlButton(
                    label: 'Flip',
                    onTap: () {
                      setState(() => isFlipped = !isFlipped);
                    },
                  ),
                  const SizedBox(width: 6),
                  _MiniControlButton(
                    label: 'Force',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Force Move')),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _MiniControlButton(
                    label: 'Baru',
                    onTap: () {
                      setState(() => _resetBoard());
                    },
                  ),
                  const SizedBox(width: 6),
                  _MiniControlButton(
                    label: 'Simpan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Pertandingan disimpan')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Notation Box
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '1. e4 e5   2. Nf3 Nc6   3. Bc4',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkDark,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Pilih bidak: titik emas = langkah, lingkaran = tangkap',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniControlButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MiniControlButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 32,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppColors.inkDark,
            side: const BorderSide(color: AppColors.inkDark, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuArenaSheet extends StatelessWidget {
  final VoidCallback onSurrender;
  final VoidCallback onFlip;
  final VoidCallback onUndo;
  final VoidCallback onForceMove;
  final VoidCallback onNewGame;
  final VoidCallback onSaveAndExit;

  const _MenuArenaSheet({
    required this.onSurrender,
    required this.onFlip,
    required this.onUndo,
    required this.onForceMove,
    required this.onNewGame,
    required this.onSaveAndExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Menu Arena',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.inkDark,
            ),
          ),
          const SizedBox(height: 14),

          _MenuSheetOption(
            title: 'Undo',
            subtitle: 'Batalkan langkah terakhir (pemain + bot)',
            onTap: onUndo,
          ),
          const SizedBox(height: 8),
          _MenuSheetOption(
            title: 'Flip papan',
            subtitle: 'Balik sudut pandang papan',
            onTap: onFlip,
          ),
          const SizedBox(height: 8),
          _MenuSheetOption(
            title: 'Force Move',
            subtitle: 'Paksa bot segera melangkah',
            onTap: onForceMove,
          ),
          const SizedBox(height: 8),
          _MenuSheetOption(
            title: 'Game baru',
            subtitle: 'Ulangi dengan draft kartu baru',
            onTap: onNewGame,
          ),
          const SizedBox(height: 8),
          _MenuSheetOption(
            title: 'Simpan dan keluar',
            subtitle: 'Simpan FEN, kekuatan, nyawa Raja',
            onTap: onSaveAndExit,
          ),

          const SizedBox(height: 18),
          DangerOutlineButton(
            label: 'MENYERAH',
            onPressed: onSurrender,
          ),
        ],
      ),
    );
  }
}

class _MenuSheetOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuSheetOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.muted, width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
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
          ],
        ),
      ),
    );
  }
}
