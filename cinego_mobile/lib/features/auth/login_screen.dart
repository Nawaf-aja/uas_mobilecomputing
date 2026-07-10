import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../home/main_shell.dart';
import 'register_screen.dart';
import 'widgets/auth_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      subtitle: 'Gerbang premium menuju dunia bioskop',
      fields: const ['Email', 'Kata Sandi'],
      action: 'Masuk',
      footer: 'Belum punya akun?',
      footerAction: 'Daftar di sini',
      onAction: (values) {
        final users = AppScope.of(context).users;
        final isValid = users.any(
          (user) =>
              user.email == values['Email'] &&
              user.password == values['Kata Sandi'],
        );

        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email atau password salah. Coba jason.ranti@gmail.com / 12345678',
              ),
            ),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      },
      onFooter: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      ),
    );
  }
}
