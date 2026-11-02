import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/stats_history_screen.dart';
import 'screens/arena_screen.dart';
import 'screens/draft_screen.dart';
import 'screens/power_reveal_screen.dart';
import 'screens/gameplay_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/puzzles_screen.dart';
import 'screens/puzzle_detail_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/ai_puzzle_generator_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ChessWarApp());
}

class ChessWarApp extends StatelessWidget {
  const ChessWarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess War Mobile',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F2F6),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.inkDark,
          primary: AppColors.inkDark,
        ),
      ),
      home: const PrototypeRootScreen(),
    );
  }
}

enum ScreenId {
  home,
  statsHistory,
  arenaDifficulty,
  draftPowers,
  powerReveal,
  gameplay,
  gameOver,
  puzzlesList,
  puzzleDetail,
  leaderboard,
  profile,
  adminPanel,
  aiPuzzleGenerator,
  register,
  login,
}

class PrototypeRootScreen extends StatefulWidget {
  const PrototypeRootScreen({super.key});

  @override
  State<PrototypeRootScreen> createState() => _PrototypeRootScreenState();
}

class _PrototypeRootScreenState extends State<PrototypeRootScreen> {
  ScreenId currentScreen = ScreenId.home;
  int currentNavIndex = 0;
  String currentPuzzleTitle = 'Back-Rank Basics';

  void _navigateTo(ScreenId screen) {
    setState(() {
      currentScreen = screen;
      // Sync bottom nav index if on a tab screen
      if (screen == ScreenId.home) currentNavIndex = 0;
      if (screen == ScreenId.arenaDifficulty) currentNavIndex = 1;
      if (screen == ScreenId.puzzlesList) currentNavIndex = 2;
      if (screen == ScreenId.leaderboard) currentNavIndex = 3;
      if (screen == ScreenId.profile) currentNavIndex = 4;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      currentNavIndex = index;
      switch (index) {
        case 0:
          currentScreen = ScreenId.home;
          break;
        case 1:
          currentScreen = ScreenId.arenaDifficulty;
          break;
        case 2:
          currentScreen = ScreenId.puzzlesList;
          break;
        case 3:
          currentScreen = ScreenId.leaderboard;
          break;
        case 4:
          currentScreen = ScreenId.profile;
          break;
      }
    });
  }

  // Quick picker dialog to test any of the 15 mockups instantly
  void _openQuickMockupPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final mockups = [
          (ScreenId.home, 'Image 2: Beranda (Halo, Asep)'),
          (ScreenId.statsHistory, 'Image 2: Statistik & Riwayat'),
          (ScreenId.arenaDifficulty, 'Image 5: Arena (Pilih tingkat bot)'),
          (ScreenId.draftPowers, 'Image 5: Draft Kekuatan (6 Kartu)'),
          (ScreenId.powerReveal, 'Image 5: Kekuatan Terpilih (Undying King)'),
          (ScreenId.gameplay, 'Image 4: Gameplay Arena vs Bot'),
          (ScreenId.gameOver, 'Image 4: Menang! (Hasil & XP)'),
          (ScreenId.puzzlesList, 'Image 3: Latihan Puzzle (Tabs)'),
          (ScreenId.puzzleDetail, 'Image 3: Puzzle Gameplay (Back-Rank)'),
          (ScreenId.leaderboard, 'Image 3: Leaderboard'),
          (ScreenId.profile, 'Image 1: Profil & Akun'),
          (ScreenId.adminPanel, 'Image 1: Panel Admin (Statistik & Menu)'),
          (ScreenId.aiPuzzleGenerator, 'Image 1: AI Puzzle Generator'),
          (ScreenId.register, 'Image 2: Buat Akun (Register)'),
          (ScreenId.login, 'Mockup: Masuk (Login)'),
        ];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Layar Mockup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.inkDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.line),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mockups.length,
                  itemBuilder: (context, index) {
                    final item = mockups[index];
                    final isCurrent = item.$1 == currentScreen;
                    return ListTile(
                      dense: true,
                      selected: isCurrent,
                      selectedTileColor: AppColors.pale,
                      title: Text(
                        item.$2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: isCurrent ? AppColors.inkDark : AppColors.muted,
                        ),
                      ),
                      trailing: isCurrent
                          ? const Icon(Icons.check,
                              color: AppColors.inkDark, size: 18)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _navigateTo(item.$1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen content
    Widget content;
    bool showNavBar = false;

    switch (currentScreen) {
      case ScreenId.home:
        showNavBar = true;
        content = HomeScreen(
          onResumeGame: () => _navigateTo(ScreenId.gameplay),
          onPlayNow: () => _navigateTo(ScreenId.arenaDifficulty),
          onViewAllHistory: () => _navigateTo(ScreenId.statsHistory),
          onOpenProfile: () => _navigateTo(ScreenId.profile),
        );
        break;

      case ScreenId.statsHistory:
        content = StatsHistoryScreen(
          onBack: () => _navigateTo(ScreenId.home),
          onResumeGame: () => _navigateTo(ScreenId.gameplay),
        );
        break;

      case ScreenId.arenaDifficulty:
        showNavBar = true;
        content = ArenaScreen(
          onContinueToDraft: (levelData) => _navigateTo(ScreenId.draftPowers),
        );
        break;

      case ScreenId.draftPowers:
        content = DraftScreen(
          onBack: () => _navigateTo(ScreenId.arenaDifficulty),
          onRevealPower: (cardNum) => _navigateTo(ScreenId.powerReveal),
        );
        break;

      case ScreenId.powerReveal:
        content = PowerRevealScreen(
          onStartMatch: () => _navigateTo(ScreenId.gameplay),
        );
        break;

      case ScreenId.gameplay:
        content = GameplayScreen(
          onBack: () => _navigateTo(ScreenId.arenaDifficulty),
          onGameOver: () => _navigateTo(ScreenId.gameOver),
        );
        break;

      case ScreenId.gameOver:
        content = GameOverScreen(
          onPlayAgain: () => _navigateTo(ScreenId.draftPowers),
          onGoHome: () => _navigateTo(ScreenId.home),
        );
        break;

      case ScreenId.puzzlesList:
        showNavBar = true;
        content = PuzzlesScreen(
          onSelectPuzzle: (title) {
            setState(() => currentPuzzleTitle = title);
            _navigateTo(ScreenId.puzzleDetail);
          },
        );
        break;

      case ScreenId.puzzleDetail:
        content = PuzzleDetailScreen(
          puzzleTitle: currentPuzzleTitle,
          onBack: () => _navigateTo(ScreenId.puzzlesList),
        );
        break;

      case ScreenId.leaderboard:
        showNavBar = true;
        content = const LeaderboardScreen();
        break;

      case ScreenId.profile:
        showNavBar = true;
        content = ProfileScreen(
          onOpenAdmin: () => _navigateTo(ScreenId.adminPanel),
          onLogout: () => _navigateTo(ScreenId.login),
        );
        break;

      case ScreenId.adminPanel:
        content = AdminScreen(
          onBack: () => _navigateTo(ScreenId.profile),
          onOpenAiPuzzleGenerator: () => _navigateTo(ScreenId.aiPuzzleGenerator),
        );
        break;

      case ScreenId.aiPuzzleGenerator:
        content = AiPuzzleGeneratorScreen(
          onBack: () => _navigateTo(ScreenId.adminPanel),
        );
        break;

      case ScreenId.register:
        content = RegisterScreen(
          onBack: () => _navigateTo(ScreenId.login),
          onRegisterSuccess: () => _navigateTo(ScreenId.home),
          onGoToLogin: () => _navigateTo(ScreenId.login),
        );
        break;

      case ScreenId.login:
        content = LoginScreen(
          onLoginSuccess: () => _navigateTo(ScreenId.home),
          onGoToRegister: () => _navigateTo(ScreenId.register),
        );
        break;
    }

    return Stack(
      children: [
        MockupPhoneFrame(
          bottomNavigationBar: showNavBar
              ? CustomBottomNavBar(
                  currentIndex: currentNavIndex,
                  onTap: _onBottomNavTap,
                )
              : null,
          child: content,
        ),

        // Floating quick screen selector badge on top-right
        Positioned(
          top: 14,
          right: 14,
          child: FloatingActionButton.extended(
            heroTag: 'mockup_switcher',
            onPressed: _openQuickMockupPicker,
            backgroundColor: AppColors.inkDark,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.dashboard_customize_outlined, size: 16),
            label: const Text(
              'Mockup Navigator',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
