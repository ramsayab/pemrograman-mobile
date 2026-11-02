import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RegisterScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterScreen({
    super.key,
    required this.onBack,
    required this.onRegisterSuccess,
    required this.onGoToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MockupHeader(
          title: 'Buat Akun',
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            children: [
              const FormLabel(text: 'NAMA'),
              const InputBox(initialValue: 'Asep Surasep'),

              const FormLabel(text: 'NAMA PENGGUNA'),
              const InputBox(initialValue: 'asep'),

              const FormLabel(text: 'EMAIL'),
              const InputBox(initialValue: 'nama@email.com'),

              const FormLabel(text: 'KATA SANDI'),
              const InputBox(
                initialValue: 'password123',
                obscureText: true,
              ),

              const FormLabel(text: 'KONFIRMASI KATA SANDI'),
              const InputBox(
                initialValue: 'password123',
                obscureText: true,
              ),

              const SizedBox(height: 6),
              const Text(
                'Kata sandi minimal 8 karakter',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.muted,
                ),
              ),

              const SizedBox(height: 20),
              PrimaryButton(
                label: 'DAFTAR',
                onPressed: onRegisterSuccess,
              ),

              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'atau daftar dengan',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.line)),
                ],
              ),

              const SizedBox(height: 14),
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
                onPressed: onRegisterSuccess,
              ),

              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: onGoToLogin,
                  child: const Text(
                    'Sudah punya akun? Masuk',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkDark,
                    ),
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
