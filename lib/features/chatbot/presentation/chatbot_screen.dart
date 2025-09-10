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

    // Colores desde el colorScheme (garantizan contraste según el theme)
    final bubbleColor = isBot ? cs.surface : cs.primaryContainer;
    final textColor = isBot ? cs.onSurface : cs.onPrimaryContainer;

    // Limitar ancho para mejor lectura
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isBot ? 6 : 14),
                  bottomRight: Radius.circular(isBot ? 14 : 6),
                ),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                m.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(chatbotControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
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
        actions: const [],
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

                  // Mostrar solo el mensaje sin botones
                  return _buildBubble(context, m, textTheme);
                },
              ),
            ),

            if (controller.loading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  color: cs.primary,
                  // ignore: deprecated_member_use
                  backgroundColor: cs.surfaceVariant,
                ),
              ),

            // Campo de texto para escribir mensajes
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                  top: BorderSide(color: cs.outline.withOpacity(0.2)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      enabled: !controller.loading,
                      decoration: InputDecoration(
                        hintText: 'Escribe tu mensaje...',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: cs.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: cs.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: cs.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: cs.surfaceVariant.withOpacity(0.3),
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                      ),
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty && !controller.loading) {
                          controller.sendUserMessage(text.trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed:
                        controller.loading
                            ? null
                            : () {
                              final text =
                                  controller.textController.text.trim();
                              if (text.isNotEmpty) {
                                controller.sendUserMessage(text);
                              }
                            },
                    icon: Icon(
                      Icons.send,
                      color:
                          controller.loading
                              ? cs.onSurface.withOpacity(0.3)
                              : cs.primary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: cs.primaryContainer.withOpacity(0.3),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Barra inferior de acciones
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
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
                      side: BorderSide(color: cs.outline),
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
