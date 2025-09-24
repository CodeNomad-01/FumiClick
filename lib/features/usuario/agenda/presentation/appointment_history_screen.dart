import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/usuario/agenda/providers/agenda_controller.dart';

class AppointmentHistoryScreen extends ConsumerWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(agendaControllerProvider);
    final cs = Theme.of(context).colorScheme;

    final all = controller.booked;
    // Agrupar por status
    final pendientes = all
        .where((a) =>  a.status.isEmpty || a.status == 'proximo')
        .toList()
      ..sort((a, b) => a.slot.compareTo(b.slot));
    final enProgreso = all
        .where((a) => a.status == 'en_progreso')
        .toList()
      ..sort((a, b) => a.slot.compareTo(b.slot));
    final completadas = all
        .where((a) => a.status == 'completada')
        .toList()
      ..sort((a, b) => b.slot.compareTo(a.slot));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: ListView(
        children: [
          _Section(
            title: 'Pendientes',
            emptyText: pendientes.isEmpty ? 'No hay citas pendientes' : null,
            children: pendientes
                .map(
                  (a) => _AppointmentTile(
                    title: a.customerName ?? 'Sin nombre',
                    subtitle: _buildSubtitle(
                      a.address,
                      a.contact,
                      a.pestType,
                      a.establishmentType,
                    ),
                    slot: a.slot,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Editar',
                          onPressed: () => _openEditSheet(
                            context,
                            ref,
                            a.id,
                            name: a.customerName,
                            contact: a.contact,
                            address: a.address,
                            pestType: a.pestType,
                            establishmentType: a.establishmentType,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          color: cs.error,
                          tooltip: 'Cancelar cita',
                          onPressed: () async {
                            final confirmed = await _confirmCancel(
                              context,
                            );
                            if (confirmed != true) return;
                            await ref
                                .read(agendaControllerProvider)
                                .cancelAppointment(a.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cita cancelada'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          _Section(
            title: 'En progreso',
            emptyText: enProgreso.isEmpty ? 'No hay citas en progreso' : null,
            children: enProgreso
                .map(
                  (a) => _AppointmentTile(
                    title: a.customerName ?? 'Sin nombre',
                    subtitle: _buildSubtitle(
                      a.address,
                      a.contact,
                      a.pestType,
                      a.establishmentType,
                    ),
                    slot: a.slot,
                  ),
                )
                .toList(),
          ),
          _Section(
            title: 'Completadas',
            emptyText: completadas.isEmpty ? 'Aún no hay citas realizadas' : null,
            children: completadas
                .map(
                  (a) => _AppointmentTile(
                    title: a.customerName ?? 'Sin nombre',
                    subtitle: _buildSubtitle(
                      a.address,
                      a.contact,
                      a.pestType,
                      a.establishmentType,
                    ),
                    slot: a.slot,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<bool?> _confirmCancel(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Cancelar cita'),
          content: const Text('¿Seguro que deseas cancelar esta cita?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _openEditSheet(
    BuildContext context,
    WidgetRef ref,
    String appointmentId, {
    String? name,
    String? contact,
    String? address,
    String? pestType,
    String? establishmentType,
  }) {
    final nameCtrl = TextEditingController(text: name ?? '');
    final contactCtrl = TextEditingController(text: contact ?? '');
    final addressCtrl = TextEditingController(text: address ?? '');
    final pestCtrl = TextEditingController(text: pestType ?? '');
    final estCtrl = TextEditingController(text: establishmentType ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: insets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Editar cita', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contactCtrl,
                  decoration: const InputDecoration(labelText: 'Contacto'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pestCtrl,
                  decoration: const InputDecoration(labelText: 'Tipo de plaga'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: estCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de establecimiento',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    await ref
                        .read(agendaControllerProvider)
                        .updateAppointment(
                          appointmentId,
                          customerName: nameCtrl.text.trim(),
                          contact: contactCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          pestType: pestCtrl.text.trim(),
                          establishmentType: estCtrl.text.trim(),
                        );
                    if (context.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cita actualizada')),
                      );
                    }
                  },
                  child: const Text('Guardar cambios'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildSubtitle(
    String? address,
    String? contact,
    String? pestType,
    String? establishmentType,
  ) {
    final parts = <String>[];
    if (address != null && address.isNotEmpty) parts.add(address);
    if (contact != null && contact.isNotEmpty) parts.add('Contacto: $contact');
    if (pestType != null && pestType.isNotEmpty) parts.add('Plaga: $pestType');
    if (establishmentType != null && establishmentType.isNotEmpty)
      parts.add('Establecimiento: $establishmentType');
    return parts.join(' • ');
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? emptyText;
  final List<Widget> children;
  const _Section({required this.title, this.emptyText, required this.children});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          if (children.isEmpty && emptyText != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(emptyText!, style: textTheme.bodyMedium),
            )
          else
            ...children,
        ],
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime slot;
  final Widget? trailing;
  const _AppointmentTile({
    required this.title,
    required this.subtitle,
    required this.slot,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(slot);
    final dateText =
        '${slot.day.toString().padLeft(2, '0')}/${slot.month.toString().padLeft(2, '0')}/${slot.year}';
    final timeText =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: const Icon(Icons.event_available),
        title: Text(title),
        subtitle: Text('$subtitle\n$dateText • $timeText'),
        isThreeLine: true,
        trailing: trailing,
      ),
    );
  }
}
