import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/tecnico_profile_provider.dart';

class TecnicoProfileScreen extends ConsumerWidget {
  const TecnicoProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final profile = ref.watch(tecnicoProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: profile == null
          ? Center(
              child: Text(
                'No autenticado',
                style: TextStyle(color: colorScheme.error),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.person, size: 48, color: colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.nombre,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.correo,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Chip(
                              label: Text(profile.rol),
                              backgroundColor: colorScheme.secondaryContainer,
                              labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () async {
                        await _signOut(context);
                      },
                      icon: const Icon(Icons.logout),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      label: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Aquí deberías llamar a FirebaseAuth.instance.signOut();
    // y navegar al login si aplica
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
