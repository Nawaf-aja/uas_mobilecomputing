import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/shared_widgets.dart';

class AuthShell extends StatefulWidget {
  const AuthShell({
    super.key,
    required this.subtitle,
    required this.fields,
    required this.action,
    required this.footer,
    required this.footerAction,
    required this.onAction,
    required this.onFooter,
  });

  final String subtitle;
  final List<String> fields;
  final String action;
  final String footer;
  final String footerAction;
  final void Function(Map<String, String> values) onAction;
  final VoidCallback onFooter;

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  late final Map<String, TextEditingController> controllers;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (final field in widget.fields)
        field: TextEditingController(
          text: field == 'Email'
              ? 'jason.ranti@gmail.com'
              : field.contains('Sandi')
              ? '12345678'
              : field == 'Nama Lengkap'
              ? 'Jason Ranti'
              : '',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void submit() {
    widget.onAction({
      for (final entry in controllers.entries)
        entry.key: entry.value.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = widget.fields.length <= 2;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -40,
            right: -40,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.red.withValues(alpha: .32),
                    AppColors.red.withValues(alpha: .08),
                    Colors.transparent,
                  ],
                  stops: const [.08, .45, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(30, 116, 30, 24),
              children: [
                const Text(
                  'CineGo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 15),
                ),
                const SizedBox(height: 64),
                for (final field in widget.fields) ...[
                  Text(
                    field,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controllers[field],
                    obscureText: field.contains('Sandi') && obscurePassword,
                    decoration: InputDecoration(
                      hintText: field == 'Email'
                          ? 'jason.ranti@gmail.com'
                          : field == 'Nama Lengkap'
                          ? 'Jason Ranti'
                          : 'password',
                      prefixIcon: Icon(
                        field == 'Email'
                            ? Icons.mail_outline
                            : field == 'Nama Lengkap'
                            ? Icons.person_outline
                            : Icons.lock_outline,
                      ),
                      suffixIcon: field.contains('Sandi')
                          ? IconButton(
                              onPressed: () => setState(
                                () => obscurePassword = !obscurePassword,
                              ),
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.field,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (isLogin) ...[
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(color: AppColors.red, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                RedButton(
                  label: widget.action,
                  icon: Icons.login,
                  onPressed: submit,
                ),
                if (isLogin) ...[
                  const SizedBox(height: 26),
                  const DividerText(label: 'Atau masuk dengan'),
                  const SizedBox(height: 22),
                  const Row(
                    children: [
                      Expanded(
                        child: SocialButton(icon: 'G', label: 'Google'),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: SocialButton(icon: 'A', label: 'Apple'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.footer,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    TextButton(
                      onPressed: widget.onFooter,
                      child: Text(
                        widget.footerAction,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DividerText extends StatelessWidget {
  const DividerText({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(label, style: const TextStyle(color: AppColors.muted)),
        ),
        const Expanded(child: Divider(color: Colors.white12)),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              color: icon == 'G' ? Colors.blueAccent : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
