import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/technical_user.dart';
import '../provider/admin_providers.dart';

class EditTechnicianDetails extends ConsumerStatefulWidget {
  final TechnicalUser technician;
  const EditTechnicianDetails({super.key, required this.technician});

  @override
  ConsumerState<EditTechnicianDetails> createState() => _EditTechnicianDetailsState();
}

class _EditTechnicianDetailsState extends ConsumerState<EditTechnicianDetails> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  String _role = 'tecnico';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.technician.name);
    _phoneCtrl = TextEditingController(text: widget.technician.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.technician.address ?? '');
    _role = widget.technician.role;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final updates = {
      'name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'role': _role,
    };
    final result = await ref.read(manageTechnicianAccountsProvider).updateTechnicianDetails(widget.technician.id, updates);
    setState(() => _saving = false);
    if (context.mounted) {
      if (result == 'success') {
        ref.invalidate(techniciansListProvider);
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados')));
      } else if (result == 'invalid_role') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rol inválido')));
      } else if (result == 'no_changes') {
        Navigator.of(context).pop(false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Resultado: $result')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar técnico'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: widget.technician.email),
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: const [
                DropdownMenuItem(value: 'tecnico', child: Text('Técnico')),
                DropdownMenuItem(value: 'usuario', child: Text('Usuario')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _role = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
        FilledButton(onPressed: _saving ? null : _save, child: _saving ? const Text('Guardando...') : const Text('Guardar Cambios')),
      ],
    );
  }
}
