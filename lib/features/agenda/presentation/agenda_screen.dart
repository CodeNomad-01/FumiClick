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
                  runSpacing: 6,
                  children:
                      m.options!.asMap().entries.map((e) {
                        final idx = e.key + 1;
                        final txt = e.value;
                        return Chip(label: Text(txt));
                      }).toList(),
                ),
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
      appBar: AppBar(
        title: const Text('Agenda de Fumigación'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(controller.isLoggedIn ? 'Sesión: ON' : 'Sesión: OFF'),
            ),
          ),
          IconButton(
            tooltip:
                controller.isLoggedIn
                    ? 'Cerrar sesión (simulado)'
                    : 'Iniciar sesión (simulado)',
            icon: Icon(controller.isLoggedIn ? Icons.logout : Icons.login),
            onPressed: () {
              if (controller.isLoggedIn) {
                controller.simulateLogout();
              } else {
                controller.simulateLogin();
              }
            },
          ),
        ],
      ),
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
                  // Renderizamos las opciones como botones numerados
                  final options = m.options!;
                  // Para calcular los índices visibles necesitamos leer el texto (ya vienen numeradas globalmente)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBubble(m),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children:
                              options.asMap().entries.map((entry) {
                                final localIdx =
                                    entry
                                        .key; // posición en este mensaje (0..n-1)
                                final label = entry.value;
                                // extraemos el número global del label si existe al principio "N) "
                                // Para simplificar el comportamiento de los botones usaremos la posición visual:
                                final displayNumber =
                                    (() {
                                      // Si el label comienza con "NN) " (opciones numeradas), parseamos ese número.
                                      final match = RegExp(
                                        r'^(\d+)\)',
                                      ).firstMatch(label);
                                      if (match != null)
                                        return int.parse(match.group(1)!);

                                      // Si no tiene número y es la opción "Mostrar más...", le asignamos
                                      // el número global correcto: (startIndex + visibleCount + 1)
                                      final lowerLabel = label.toLowerCase();
                                      if (lowerLabel.contains('mostrar')) {
                                        return controller
                                                .currentPageStartIndex +
                                            controller.visibleOptionsCount +
                                            1;
                                      }

                                      // Fallback: usar un número seguro (esto casi no ocurrirá)
                                      return controller.currentPageStartIndex +
                                          localIdx +
                                          1;
                                    })();
                                // Botón habilitado solo cuando no esté cargando
                                return ElevatedButton(
                                  onPressed:
                                      controller.loading
                                          ? null
                                          : () {
                                            controller.userSelectOption(
                                              displayNumber,
                                            );
                                          },
                                  child: Text(
                                    label.startsWith(RegExp(r'\d+\)'))
                                        ? label.split(')')[0]
                                        : label,
                                  ),
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
                  onPressed:
                      controller.loading
                          ? null
                          : () => controller.startConversation(),
                  child: const Text('Reiniciar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      controller.loading
                          ? null
                          : () => controller.clearConversation(),
                  child: const Text('Limpiar'),
                ),
                const Spacer(),
                Text(
                  'Reservadas: ${controller.repository.getBookedAppointments().length}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
