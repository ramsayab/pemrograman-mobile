import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MockupHeader(title: 'Masuk'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    border: Border.all(color: AppColors.inkDark, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '♚',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Selamat datang kembali di Chess War',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const FormLabel(text: 'EMAIL'),
              const InputBox(initialValue: 'nama@email.com'),
              const FormLabel(text: 'KATA SANDI'),
              const InputBox(
                initialValue: 'password123',
                obscureText: true,
                suffix: 'Tampil',
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'MASUK',
                onPressed: onLoginSuccess,
              ),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'atau masuk dengan',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.line)),
                ],
              ),
              const SizedBox(height: 16),
              OutlineButton(
                label: 'Akun Google',
                leading: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.inkDark),
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkDark,
                      ),
                    ),
                  ),
                ),
                onPressed: onLoginSuccess,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: onGoToRegister,
                  child: const Text(
                    'Belum punya akun? Daftar',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
