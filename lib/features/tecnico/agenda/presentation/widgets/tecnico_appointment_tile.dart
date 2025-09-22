import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/tecnico_appointment.dart';

class TecnicoAppointmentTile extends StatelessWidget {
  final TecnicoAppointment cita;
  final VoidCallback? onTap;

  const TecnicoAppointmentTile({Key? key, required this.cita, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _TecnicoAppointmentTileContent(cita: cita),
        ),
      ),
    );
  }

  // ...
}

class _TecnicoAppointmentTileContent extends StatefulWidget {
  final TecnicoAppointment cita;
  const _TecnicoAppointmentTileContent({required this.cita});

  @override
  State<_TecnicoAppointmentTileContent> createState() => _TecnicoAppointmentTileContentState();
}

class _TecnicoAppointmentTileContentState extends State<_TecnicoAppointmentTileContent> {
  late String _estado;
  bool _cambiando = false;
  bool _modificado = false;

  final List<String> estados = ['pendiente', 'completada', 'cancelada'];

  @override
  void initState() {
    super.initState();
    _estado = widget.cita.estado ?? 'pendiente';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event, color: cs.primary),
            const SizedBox(width: 8),
            Text(_formatFechaHora(widget.cita.slot), style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<String>(
                value: _estado,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                items: estados
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e[0].toUpperCase() + e.substring(1),
                            style: TextStyle(
                              color: e == 'completada'
                                  ? cs.primary
                                  : e == 'cancelada'
                                      ? cs.error
                                      : cs.onSurface,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _estado = value;
                      _modificado = value != (widget.cita.estado ?? 'pendiente');
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.person, color: cs.secondary),
            const SizedBox(width: 6),
            Expanded(child: Text(widget.cita.clienteNombre, style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on, color: cs.tertiary),
            const SizedBox(width: 6),
            Expanded(child: Text(widget.cita.direccion, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.bug_report, color: cs.error),
            const SizedBox(width: 6),
            Expanded(child: Text(widget.cita.tipoServicio, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 12),
        if (_modificado)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: _cambiando ? const Text('Guardando...') : const Text('Confirmar estado'),
              onPressed: _cambiando
                  ? null
                  : () async {
                      setState(() {
                        _cambiando = true;
                      });
                      await _actualizarEstado(widget.cita.id, _estado);
                      setState(() {
                        _cambiando = false;
                        _modificado = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Estado actualizado a "${_estado[0].toUpperCase() + _estado.substring(1)}"')),
                      );
                    },
            ),
          ),
      ],
    );
  }

  String _formatFechaHora(DateTime slot) {
    final day = slot.day.toString().padLeft(2, '0');
    final month = slot.month.toString().padLeft(2, '0');
    final hour = slot.hour.toString().padLeft(2, '0');
    final minute = slot.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }

  Future<void> _actualizarEstado(String citaId, String nuevoEstado) async {
    final db = FirebaseFirestore.instance;
    await db.collection('appointments').doc(citaId).update({'estado': nuevoEstado});
  }
}
