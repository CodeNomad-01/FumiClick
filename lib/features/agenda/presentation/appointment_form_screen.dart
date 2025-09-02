import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/agenda/presentation/widgets/appointment_form_widget.dart';
import 'package:fumi_click/features/agenda/providers/agenda_controller.dart';

class AppointmentFormScreen extends ConsumerWidget {
  const AppointmentFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(agendaControllerProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Fumigación', style: textTheme.titleLarge),
        backgroundColor: cs.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadSlots,
            tooltip: 'Recargar franjas',
          ),
        ],
      ),
      body: SafeArea(child: const AppointmentFormWidget()),
    );
  }
}
