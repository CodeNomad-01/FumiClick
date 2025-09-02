import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/agenda/presentation/widgets/slot_title.dart';
import 'package:fumi_click/features/chatbot/data/chatbot_repository.dart';

import '../../providers/agenda_controller.dart';

class AppointmentFormWidget extends ConsumerStatefulWidget {
  const AppointmentFormWidget({super.key});

  @override
  ConsumerState<AppointmentFormWidget> createState() =>
      _AppointmentFormWidgetState();
}

class _AppointmentFormWidgetState
    extends ConsumerState<AppointmentFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController contactController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(agendaControllerProvider);
    nameController = TextEditingController(text: controller.request.name ?? '');
    contactController =
        TextEditingController(text: controller.request.contact ?? '');
    addressController =
        TextEditingController(text: controller.request.address ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(agendaControllerProvider);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Solicitante', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              onChanged: controller.updateName,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contacto (teléfono/celular)',
              ),
              onChanged: controller.updateContact,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration:
                  const InputDecoration(labelText: 'Dirección del local'),
              onChanged: controller.updateAddress,
            ),
            const SizedBox(height: 16),
            Text('Franjas disponibles', style: textTheme.titleMedium),
            const SizedBox(height: 8),

            if (controller.loading) const LinearProgressIndicator(),

            ...controller.visibleSlots.map((s) {
              final selected = controller.request.chosenSlot != null &&
                  AppointmentRepository.isSameSlot(
                    controller.request.chosenSlot!,
                    s,
                  );
              return SlotTile(
                slot: s,
                selected: selected,
                onTap: () => controller.selectSlot(s),
              );
            }).toList(),

            if (controller.hasMoreOptions)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: OutlinedButton(
                  onPressed: controller.showMore,
                  child: const Text('Mostrar más'),
                ),
              ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: controller.loading
                  ? null
                  : () async {
                      try {
                        await controller.submitForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cita reservada correctamente'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Reservar cita'),
              ),
            ),

            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: controller.reset,
              child: const Text('Limpiar formulario'),
            ),

            const SizedBox(height: 16),
            Text(
              'Reservadas: ${controller.repository.getBookedAppointments().length}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
