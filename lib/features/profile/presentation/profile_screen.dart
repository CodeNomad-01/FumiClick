import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_notifier_provider.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';
import 'package:fumi_click/features/profile/presentation/user_not_found.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nota: si quieres que reaccione a cambios del usuario, usa watch en lugar de read.
    final userAsyncValue = ref.watch(userAuthProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return userAsyncValue.when(
      data: (user) {
        return user == null
            ? const UserNotFound()
            : Scaffold(
              backgroundColor: colorScheme.surface,
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        // Reemplazo de surfaceVariant -> surfaceContainerHigh
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          // Reemplazo de onSurfaceVariant -> onSurface
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        user.email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          // onSurface con ligera atenuación para texto secundario
                          color: colorScheme.onSurface.withValues(alpha: 0.80),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Material 3: FilledButton en lugar de ElevatedButton
                      FilledButton(
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).logout();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
