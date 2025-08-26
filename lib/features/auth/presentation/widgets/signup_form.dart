import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/utils/validators.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            // ----------------- Nombre -----------------
            TextFormField(
              controller: _nameController,
              validator: notNullOrEmpty,
              decoration: InputDecoration(
                labelText: "Nombre",
                hintText: "Ingresa tu nombre completo",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------------- Email -----------------
            TextFormField(
              controller: _emailController,
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                return emailValidator(value!);
              },
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Ingresa tu correo electrónico",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------------- Contraseña -----------------
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                return passwordValidator(value!);
              },
              decoration: InputDecoration(
                labelText: "Contraseña",
                hintText: "Crea una contraseña segura",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----------------- Confirmar Contraseña -----------------
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              validator: (value) {
                String? notEmpty = notNullOrEmpty(value);
                if (notEmpty != null) return notEmpty;
                return confirmPasswordValidator(
                  _passwordController.text,
                  value!,
                );
              },
              decoration: InputDecoration(
                labelText: "Confirmar Contraseña",
                hintText: "Confirma tu contraseña",
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isTablet ? 20 : 16,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ----------------- Botón -----------------
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(authNotifierProvider.notifier)
                      .register(
                        _emailController.text,
                        _passwordController.text,
                      );
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Registrar",
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
