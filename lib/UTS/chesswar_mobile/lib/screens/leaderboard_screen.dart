import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String searchQuery = '';

  final List<Map<String, dynamic>> players = [
    {'rank': 1, 'name': 'Asep (Kamu)', 'main': 5, 'menang': 1, 'wr': '20%', 'isCurrent': true},
    {'rank': 2, 'name': 'Zefhana 06', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 3, 'name': 'spirit walker', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 4, 'name': 'tyty', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 5, 'name': 'Alatol', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 6, 'name': 'Alana', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 7, 'name': 'Ecec', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
    {'rank': 8, 'name': 'Srahudin', 'main': 0, 'menang': 0, 'wr': '0%', 'isCurrent': false},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = players.where((p) {
      if (searchQuery.isEmpty) return true;
      return (p['name'] as String)
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        const MockupHeader(title: 'Leaderboard'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InputBox(
            placeholder: 'Cari nama / username...',
            suffixIcon: const Icon(Icons.search, size: 18, color: AppColors.muted),
            onChanged: (val) => setState(() => searchQuery = val),
          ),
        ),
        const SizedBox(height: 12),
        // Table Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.inkDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: const [
              SizedBox(
                width: 24,
                child: Text(
                  '#',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'PEMAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  'MAIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 52,
                child: Text(
                  'MENANG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  'WR',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        // List of players
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredPlayers.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: AppColors.line,
            ),
            itemBuilder: (context, index) {
              final player = filteredPlayers[index];
              final isCurrent = player['isCurrent'] as bool;

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                color: isCurrent ? AppColors.pale : AppColors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${player['rank']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkDark,
                        ),
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line, width: 1.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        player['name'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isCurrent ? FontWeight.w800 : FontWeight.w600,
                          color: AppColors.inkDark,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${player['main']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52,
                      child: Text(
                        '${player['menang']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        player['wr'] as String,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '... menampilkan 20 teratas ...',
              style: TextStyle(fontSize: 10, color: AppColors.muted),
            ),
          ),
        ),
        // Pinned bottom user ranking card
        Container(
          margin: const EdgeInsets.fromLTRB(20, 6, 20, 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.line, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PERINGKAT KAMU',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Text(
                      '#42   Asep (Kamu)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                  Text(
                    '5 main  |  1 menang',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
