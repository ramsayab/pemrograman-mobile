import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onOpenAdmin;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.onOpenAdmin,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MockupHeader(title: 'Profil'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              const SizedBox(height: 12),
              // Avatar with plus badge
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: AppColors.boardLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.inkDark, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.inkDark,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.inkDark, width: 1.8),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.inkDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // User Name
              const Center(
                child: Text(
                  'Asep Surasep',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inkDark,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  '@asep  |  Lv. 1  |  825 XP',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Items
              _ProfileMenuItem(
                title: 'Ubah nama dan username',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialog Ubah Nama & Username')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ProfileMenuItem(
                title: 'Ubah kata sandi',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialog Ubah Kata Sandi')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ProfileMenuItem(
                title: 'Ubah foto (kamera / galeri)',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dialog Ubah Foto')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ProfileMenuItem(
                title: 'Panel Admin',
                badge: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                onTap: onOpenAdmin,
              ),

              const SizedBox(height: 24),
              // KELUAR button
              DangerOutlineButton(
                label: 'KELUAR',
                onPressed: onLogout,
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Panel Admin hanya tampil untuk peran admin',
                  style: TextStyle(
                    fontSize: 10,
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

class _ProfileMenuItem extends StatelessWidget {
  final String title;
  final Widget? badge;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.title,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkDark,
                ),
              ),
            ),
            if (badge != null) ...[
              badge!,
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
