import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';
import 'package:fumi_click/features/profile/presentation/user_not_found.dart';
import 'package:fumi_click/features/profile/provider/user_profile_provider.dart';
import 'package:fumi_click/features/profile/data/user_profile.dart';

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
    final profileAsync = ref.watch(userProfileStreamProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return userAsyncValue.when(
      data: (user) {
        if (user == null) return const UserNotFound();

        profileAsync.whenData((profile) {
          _nameController.text = profile?.name ?? (user.displayName ?? '');
          _phoneController.text = profile?.phone ?? '';
          _addressController.text = profile?.address ?? '';
        });

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
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: user.email ?? ''),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      final toSave = UserProfile(
                        userId: user.uid,
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        address: _addressController.text.trim(),
                      );
                      await ref
                          .read(userProfileRepositoryProvider)
                          .saveCurrentUserProfile(toSave);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Perfil actualizado')),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: const Text('Guardar cambios'),
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
