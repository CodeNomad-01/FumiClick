import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tecnico_appointments_provider.dart';
import '../presentation/widgets/tecnico_appointment_tile.dart';
import '../data/models/tecnico_appointment.dart';

class TecnicoAppointmentsScreen extends ConsumerWidget {
  const TecnicoAppointmentsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citasAsync = ref.watch(tecnicoAppointmentsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      
      body: citasAsync.when(
        data: (citas) {
          if (citas.isEmpty) {
            return const Center(child: Text('No tienes citas programadas.'));
          }
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return TecnicoAppointmentTile(
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
    await db.collection('appointments').doc(citaId).update({'estado': nuevoEstado});
  }

  void _showDetalleCita(BuildContext context, TecnicoAppointment cita) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de la cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${cita.clienteNombre}'),
            Text('Dirección: ${cita.direccion}'),
            Text('Hora: ${cita.slot.hour.toString().padLeft(2, '0')}:${cita.slot.minute.toString().padLeft(2, '0')}'),
            Text('Servicio: ${cita.tipoServicio}'),
            Text('Teléfono: ${cita.contact}'),
            const SizedBox(height: 16),
            Text('Estado actual: ${cita.estado ?? 'Sin estado'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
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
}
