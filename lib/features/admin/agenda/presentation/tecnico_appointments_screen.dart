import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tecnico_appointments_provider.dart';
import 'widgets/tecnico_appointment_tile.dart';
import '../data/models/admin_appointment.dart';
import 'observations_screen.dart';

class AdminAppointmentsScreen extends ConsumerWidget {
  const AdminAppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citasAsync = ref.watch(tecnicoAppointmentsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),

      body: citasAsync.when(
        data: (citas) {
          if (citas.isEmpty) {
            return const Center(child: Text('No tienes citas programadas.'));
          }
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return AdminAppointmentTile(
                cita: cita,
                onTap: () => _showDetalleCita(context, cita),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _cambiarEstadoCita(String citaId, String nuevoEstado) async {
    final db = FirebaseFirestore.instance;
    await db.collection('appointments').doc(citaId).update({
      'estado': nuevoEstado,
    });
  }

  void _showDetalleCita(BuildContext context, AdminAppointment cita) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Detalle de la cita'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: ${cita.clienteNombre}'),
                  Text('Dirección: ${cita.direccion}'),
                  Text(
                    'Hora: ${cita.slot.hour.toString().padLeft(2, '0')}:${cita.slot.minute.toString().padLeft(2, '0')}',
                  ),
                  Text('Servicio: ${cita.tipoServicio}'),
                  Text('Teléfono: ${cita.contact}'),
                  const SizedBox(height: 16),
                  Text('Estado actual: ${cita.estado ?? 'Sin estado'}'),

                  // Mostrar observaciones si existen
                  if (cita.observaciones != null || cita.hallazgos != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Evidencia de la Visita:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (cita.observaciones != null) ...[
                      Text(
                        'Observaciones:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        cita.observaciones!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (cita.hallazgos != null) ...[
                      Text(
                        'Hallazgos:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        cita.hallazgos!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (cita.fechaObservaciones != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Registrado: ${_formatFechaObservaciones(cita.fechaObservaciones!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ObservationsScreen(appointment: cita),
                    ),
                  );
                },
                icon: const Icon(Icons.note_add),
                label: const Text('Registrar Observaciones'),
              ),
              TextButton(
                onPressed: () async {
                  await _cambiarEstadoCita(cita.id, 'completada');
                  Navigator.pop(context);
                },
                child: const Text('Marcar como completada'),
              ),
              TextButton(
                onPressed: () async {
                  await _cambiarEstadoCita(cita.id, 'cancelada');
                  Navigator.pop(context);
                },
                child: const Text('Cancelar cita'),
              ),
            ],
          ),
    );
  }

  String _formatFechaObservaciones(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year;
    final hour = fecha.hour.toString().padLeft(2, '0');
    final minute = fecha.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
