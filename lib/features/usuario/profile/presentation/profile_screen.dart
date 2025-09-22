import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';
import 'package:fumi_click/features/usuario/profile/presentation/user_not_found.dart';
import 'package:fumi_click/features/usuario/profile/presentation/edit_profile_screen.dart';
import 'package:fumi_click/features/usuario/profile/provider/user_profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userAuthProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return userAsyncValue.when(
      data: (user) {
        if (user == null) return const UserNotFound();

        final profileByEmailAsync = ref.watch(
          userProfileByEmailProvider(user.email ?? ''),
        );

        return profileByEmailAsync.when(
          data: (profile) {
            if (profile == null) return const UserNotFound();
            _nameController.text = profile.name ?? (user.displayName ?? '');
            _phoneController.text = profile.phone ?? '';
            _addressController.text = profile.address ?? '';
            final userRole = profile.role ?? 'usuario';

            return Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                title: const Text('Mi Perfil'),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Datos personales', style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.verified_user, size: 20),
                          const SizedBox(width: 8),
                          Text('Rol: ', style: textTheme.bodyMedium),
                          Text(
                            userRole,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Nombre',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        profile.name ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Correo electrónico',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Teléfono',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        profile.phone ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Dirección',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        profile.address ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                          // Actualizar los datos locales después de editar
                          ref.invalidate(
                            userProfileByEmailProvider(user.email ?? ''),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: const Text('Actualizar datos'),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).logout();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        child: const Text('Cerrar sesión'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading:
              () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
          error:
              (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
        );
      },
      error:
          (error, stack) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
    );
  }
}
