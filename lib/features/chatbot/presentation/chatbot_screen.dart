import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/utils/material-theme/lib/util.dart';
import '../infrastructure/chatbot_controller.dart';
import '../data/chatbot_repository.dart';

final chatbotControllerProvider = ChangeNotifierProvider<AgendaController>((
  ref,
) {
  return AgendaController(repository: AppointmentRepository());
});

class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  Widget _buildBubble(
    BuildContext context,
    ChatMessage m,
    TextTheme textTheme,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isBot = m.sender == Sender.bot;

    // Mejora de contraste: usamos tokens del colorScheme que garantizan legibilidad
    final bubbleColor = isBot ? cs.surface : cs.primary;
    final textColor = isBot ? cs.onSurface : cs.onPrimary;

    // Limitar ancho para que las burbujas no ocupen toda la pantalla
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          // Burbuja con sombra ligera y radio más pronunciado
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isBot ? 4 : 14), // 'cola' sutil
                  bottomRight: Radius.circular(isBot ? 14 : 4), // 'cola' sutil
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Texto con tamaño cómodo y buen contraste
                  Text(
                    m.text,
                    style: textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontSize: 15,
                    ),
                  ),
                  if (m.options != null) const SizedBox(height: 8),
                  if (m.options != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                          m.options!.asMap().entries.map((e) {
                            final txt = e.value;
                            return Chip(
                              backgroundColor: cs.surfaceVariant,
                              label: Text(
                                txt,
                                style: textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos el controller desde Riverpod
    final controller = ref.watch(chatbotControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Ajusta aquí los nombres de las fuentes si quieres otros
    final textTheme = createTextTheme(context, 'Inter', 'Roboto');

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Agenda de Fumigación',
          style: textTheme.titleLarge?.copyWith(
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: cs.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                controller.isLoggedIn ? 'Sesión: ON' : 'Sesión: OFF',
                style: textTheme.bodyMedium?.copyWith(
                  color: cs.onPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip:
                controller.isLoggedIn
                    ? 'Cerrar sesión (simulado)'
                    : 'Iniciar sesión (simulado)',
            icon: Icon(
              controller.isLoggedIn ? Icons.logout : Icons.login,
              color: cs.onPrimary,
            ),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                itemCount: controller.messages.length,
                itemBuilder: (context, i) {
                  final m = controller.messages[i];

                  // Si el mensaje tiene opciones, renderizamos con botones debajo
                  if (m.options != null && m.options!.isNotEmpty) {
                    final options = m.options!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildBubble(context, m, textTheme),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children:
                                options.asMap().entries.map((entry) {
                                  final localIdx = entry.key;
                                  final label = entry.value;

                                  // Determinar número global de la opción (robusto)
                                  final displayNumber =
                                      (() {
                                        final match = RegExp(
                                          r'^(\d+)\)',
                                        ).firstMatch(label);
                                        if (match != null) {
                                          return int.parse(match.group(1)!);
                                        }

                                        final lowerLabel = label.toLowerCase();
                                        if (lowerLabel.contains('mostrar')) {
                                          return controller
                                                  .currentPageStartIndex +
                                              controller.visibleOptionsCount +
                                              1;
                                        }

                                        return controller
                                                .currentPageStartIndex +
                                            localIdx +
                                            1;
                                      })();

                                  // Texto del botón: si el label tiene "N) ..." mostramos N, si no mostramos el label completo
                                  final buttonText =
                                      (RegExp(r'^\d+\)').hasMatch(label))
                                          ? label.split(')')[0]
                                          : label;

                                  // Botones con tamaño y estilo legible
                                  return SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        textStyle: textTheme.bodyMedium
                                            ?.copyWith(fontSize: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          controller.loading
                                              ? null
                                              : () {
                                                controller.userSelectOption(
                                                  displayNumber,
                                                );
                                              },
                                      child: Text(
                                        buttonText,
                                        style: textTheme.labelLarge?.copyWith(
                                          color: cs.onPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return _buildBubble(context, m, textTheme);
                  }
                },
              ),
            ),

            // Indicador de carga: toma color del theme
            if (controller.loading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  color: cs.primary,
                  backgroundColor: cs.surfaceVariant,
                ),
              ),

            // Barra inferior de acciones (sin cambios funcionales, sólo estilo)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed:
                        controller.loading
                            ? null
                            : () => controller.startConversation(),
                    child: Text('Reiniciar', style: textTheme.labelLarge),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      textStyle: textTheme.labelLarge,
                    ),
                    onPressed:
                        controller.loading
                            ? null
                            : () => controller.clearConversation(),
                    child: Text('Limpiar', style: textTheme.labelLarge),
                  ),
                  const Spacer(),
                  Text(
                    'Reservadas: ${controller.repository.getBookedAppointments().length}',
                    style: textTheme.bodySmall?.copyWith(color: cs.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
