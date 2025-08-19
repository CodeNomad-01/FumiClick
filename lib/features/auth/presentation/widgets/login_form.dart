import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/utils/validators.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Campo de email
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
              controller: _emailController,
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                String? email = emailValidator(value!);
                return email;
              },
            ),
            const SizedBox(height: 20),

            // Campo de password
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
              controller: _passwordController,
              validator: notNullOrEmpty,
              obscureText: true,
            ),

            const SizedBox(height: 32),

            // Botón adaptado a M3
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56), // full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(authNotifierProvider.notifier).login(
                        _emailController.text,
                        _passwordController.text,
                      );
                }
              },
              child: Text(
                "Iniciar sesión",
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
