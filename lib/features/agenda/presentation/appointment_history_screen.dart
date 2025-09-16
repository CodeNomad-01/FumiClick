import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/agenda/providers/agenda_controller.dart';

class AppointmentHistoryScreen extends ConsumerWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(agendaControllerProvider);
    final cs = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final all = controller.booked;
    final past =
        all.where((a) => a.slot.isBefore(now)).toList()
          ..sort((a, b) => b.slot.compareTo(a.slot));
    final upcoming =
        all.where((a) => !a.slot.isBefore(now)).toList()
          ..sort((a, b) => a.slot.compareTo(b.slot));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: ListView(
        children: [
          if (upcoming.isNotEmpty)
            _Section(
              title: 'Próximas',
              children:
                  upcoming
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
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            color: cs.error,
                            tooltip: 'Cancelar cita',
                            onPressed: () async {
                              final confirmed = await _confirmCancel(context);
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
                        ),
                      )
                      .toList(),
            ),
          _Section(
            title: 'Realizadas',
            emptyText: past.isEmpty ? 'Aún no hay citas realizadas' : null,
            children:
                past
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
