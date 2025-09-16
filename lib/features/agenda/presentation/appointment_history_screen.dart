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
        title: const Text('Historial de Citas'),
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
                          subtitle: a.address ?? a.contact ?? '',
                          slot: a.slot,
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
                        subtitle: a.address ?? a.contact ?? '',
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
  const _AppointmentTile({
    required this.title,
    required this.subtitle,
    required this.slot,
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
      ),
    );
  }
}
