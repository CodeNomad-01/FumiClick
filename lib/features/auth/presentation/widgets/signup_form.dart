import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/features/usuario/profile/data/user_profile.dart';
import 'package:fumi_click/features/usuario/profile/provider/user_profile_provider.dart';
import 'package:fumi_click/utils/validators.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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

            // ----------------- Teléfono -----------------
            TextFormField(
              controller: _phoneController,
              validator: notNullOrEmpty,
              decoration: InputDecoration(
                labelText: "Teléfono",
                hintText: "Ingresa tu número de teléfono",
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

            // ----------------- Dirección -----------------
            TextFormField(
              controller: _addressController,
              validator: notNullOrEmpty,
              decoration: InputDecoration(
                labelText: "Dirección",
                hintText: "Ingresa tu dirección",
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Registrar usuario en Firebase Auth
                  await ref.read(authNotifierProvider.notifier).register(
                    _emailController.text,
                    _passwordController.text,
                  );

                  // Guardar perfil en Firestore con los datos del formulario y rol 'usuario'
                  final user = ref.read(authNotifierProvider.notifier).currentUser;
                  if (user != null) {
                    final profile = UserProfile(
                      userId: user.uid,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      address: _addressController.text,
                      role: 'usuario',
                      email: _emailController.text,
                    );
                    await ref.read(saveUserProfileProvider(profile).future);
                  }
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
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
