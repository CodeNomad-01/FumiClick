import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/admin_providers.dart';
import '../data/models/technical_user.dart';
import 'edit_technician_details.dart';

class TechnicalAccountManagerScreen extends ConsumerWidget {
  const TechnicalAccountManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniciansAsync = ref.watch(techniciansListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Técnicos')),
      body: techniciansAsync.when(
        data: (list) => _buildList(context, ref, list),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Asignar Rol Técnico (por Correo)'),
        icon: const Icon(Icons.person_add),
        onPressed: () => _showAssignDialog(context, ref),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<TechnicalUser> list) {
    if (list.isEmpty) return const Center(child: Text('No hay técnicos registrados.'));
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final t = list[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(t.name),
            subtitle: Text('${t.email}\n${t.phone ?? ''}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar',
                  onPressed: () async {
                    final updated = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => EditTechnicianDetails(technician: t),
                    );
                    if (updated == true) {
                      ref.invalidate(techniciansListProvider);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Desactivar técnico',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Desactivar técnico'),
                        content: Text('¿Desactivar a ${t.name}? Esto lo convertirá en usuario.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sí')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref.read(manageTechnicianAccountsProvider).deactivateTechnician(t.id);
                      // refresh list
                      ref.invalidate(techniciansListProvider);
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Técnico desactivado')));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAssignDialog(BuildContext context, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Asignar Rol Técnico'),
          content: TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                final result = await ref.read(manageTechnicianAccountsProvider).assignRoleByEmail(email);
                Navigator.of(ctx).pop();
                if (result == 'not_found') {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El usuario no existe.')));
                } else if (result == 'is_admin') {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Un administrador no puede pasar a ser técnico.')));
                } else if (result == 'already') {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El usuario ya es técnico.')));
                } else if (result == 'success') {
                  ref.invalidate(techniciansListProvider);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rol asignado con éxito.')));
                } else {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Resultado: $result')));
                }
              },
              child: const Text('Asignar'),
            ),
          ],
        );
      },
    );
  }
}
