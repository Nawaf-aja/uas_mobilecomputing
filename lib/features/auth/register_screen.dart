import 'package:flutter/material.dart';

import '../home/main_shell.dart';
import 'widgets/auth_shell.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      subtitle: 'Daftar sekarang dan nikmati pengalaman menonton terbaik.',
      fields: const [
        'Nama Lengkap',
        'Email',
        'Kata Sandi',
        'Konfirmasi Kata Sandi',
      ],
      action: 'Daftar',
      footer: 'Sudah punya akun?',
      footerAction: 'Masuk',
      onAction: (values) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      ),
      onFooter: () => Navigator.pop(context),
    );
  }
}
