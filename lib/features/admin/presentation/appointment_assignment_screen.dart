import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/admin_providers.dart';
import '../data/appointment.dart';
import '../data/models/technical_user.dart';

class AppointmentAssignmentScreen extends ConsumerStatefulWidget {
  const AppointmentAssignmentScreen({super.key});

  @override
  ConsumerState<AppointmentAssignmentScreen> createState() => _AppointmentAssignmentScreenState();
}

class _AppointmentAssignmentScreenState extends ConsumerState<AppointmentAssignmentScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchCtrl.text.trim();
    final unassignedAsync = ref.watch(unassignedAppointmentsProvider(search.isEmpty ? null : search));
    final techsAsync = ref.watch(techniciansListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Asignación de Citas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar por cliente o dirección'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: unassignedAsync.when(
              data: (list) => _buildList(context, ref, list, techsAsync),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Appointment> list, AsyncValue<List<TechnicalUser>> techsAsync) {
    if (list.isEmpty) return const Center(child: Text('No hay citas sin asignar.'));
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final a = list[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(a.customerName ?? 'Sin nombre'),
            subtitle: Text('${a.address}\nContacto: ${a.contact}\n${_formatSlot(a.slot)}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.call),
                  tooltip: 'Llamar',
                  onPressed: a.contact.isEmpty ? null : () => _callNumber(a.contact),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar dirección',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: a.address));
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dirección copiada')));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Detalles',
                  onPressed: () => _showDetailsDialog(context, a),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  child: const Text('Asignar'),
                  onPressed: () => _openAssignDialog(context, ref, a, techsAsync),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatSlot(DateTime slot) {
    final day = slot.day.toString().padLeft(2, '0');
    final month = slot.month.toString().padLeft(2, '0');
    final year = slot.year;
    final hour = slot.hour.toString().padLeft(2, '0');
    final minute = slot.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  void _showDetailsDialog(BuildContext context, Appointment a) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(a.customerName ?? 'Detalle de cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dirección: ${a.address}'),
            const SizedBox(height: 6),
            Text('Contacto: ${a.contact}'),
            const SizedBox(height: 6),
            Text('Email cliente: ${a.email ?? '-'}'),
            const SizedBox(height: 6),
            Text('Técnico asignado: ${a.technicianEmail ?? 'No asignado'}'),
            const SizedBox(height: 6),
            Text('Fecha/Hora: ${_formatSlot(a.slot)}'),
            const SizedBox(height: 6),
            Text('Estado: ${a.status}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cerrar'))],
      ),
    );
  }

  void _openAssignDialog(BuildContext context, WidgetRef ref, Appointment appointment, AsyncValue<List<TechnicalUser>> techsAsync) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Asignar cita: ${appointment.customerName ?? ''}'),
          content: techsAsync.when(
            data: (techs) {
              String? selected;
              final items = techs.map((t) => DropdownMenuItem(value: t.email, child: Text('${t.name} (${t.email})'))).toList();
              return StatefulBuilder(builder: (c, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      items: items,
                      value: selected,
                      onChanged: (v) => setState(() => selected = v),
                      decoration: const InputDecoration(labelText: 'Técnico'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (selected == null) return;
                        final result = await ref.read(manageAppointmentAssignmentProvider).assignTechnician(appointment.id, selected!);
                        Navigator.of(ctx).pop();
                        if (result == 'success') {
                          final search = _searchCtrl.text.trim();
                          ref.invalidate(unassignedAppointmentsProvider(search.isEmpty ? null : search));
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cita asignada')));
                        } else {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error asignando cita')));
                        }
                      },
                      child: const Text('Confirmar asignación'),
                    ),
                  ],
                );
              });
            },
            loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
            error: (e, s) => Text('Error cargando técnicos: $e'),
          ),
        );
      },
    );
  }
}
