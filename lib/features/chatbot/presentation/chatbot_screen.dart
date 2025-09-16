import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/chatbot_controller.dart';
import '../infrastructure/firestore_chatbot_repository.dart';

final chatbotControllerProvider = ChangeNotifierProvider<AgendaController>((
  ref,
) {
  return AgendaController(repository: ChatbotFirestoreRepository());
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
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Text(
                m.text,
                style: textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final controller = ref.watch(chatbotControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot de Agenda'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final m = controller.messages[index];
                return _buildBubble(context, m, textTheme);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje... (o un número)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      controller.loading
                          ? null
                          : () async {
                            final text = controller.textController.text.trim();
                            if (text.isEmpty) return;
                            await controller.sendUserMessage(text);
                          },
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
