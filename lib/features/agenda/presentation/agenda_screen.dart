import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'agenda_controller.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  Widget _buildBubble(ChatMessage m) {
    final isBot = m.sender == Sender.bot;
    final alignment = isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final color = isBot ? Colors.grey.shade200 : Colors.blue.shade200;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.text),
              if (m.options != null) const SizedBox(height: 8),
              if (m.options != null)
                Wrap(
                  spacing: 8,
                  children: m.options!.asMap().entries.map((e) {
                    final idx = e.key + 1;
                    final txt = e.value;
                    return Chip(label: Text('$idx. $txt'));
                  }).toList(),
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AgendaController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de Fumigación')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: controller.messages.length,
              itemBuilder: (context, i) {
                final m = controller.messages[i];
                // Si el mensaje tiene opciones, renderizamos con botones debajo
                if (m.options != null && m.options!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBubble(m),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: m.options!.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final label = entry.value;
                            return ElevatedButton(
                              onPressed: controller.loading
                                  ? null
                                  : () {
                                      controller.userSelectOption(idx);
                                    },
                              child: Text('$idx'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return _buildBubble(m);
                }
              },
            ),
          ),
          if (controller.loading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: controller.loading ? null : () => controller.startConversation(),
                  child: const Text('Reiniciar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.loading ? null : () => controller.clearConversation(),
                  child: const Text('Limpiar'),
                ),
                const Spacer(),
                Text('Reservadas: ${controller.repository.getBookedAppointments().length}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
