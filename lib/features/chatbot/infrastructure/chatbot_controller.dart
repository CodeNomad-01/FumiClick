import 'package:flutter/material.dart';
import 'firestore_chatbot_repository.dart';

enum Sender { bot, user, system }

class ChatMessage {
  final Sender sender;
  final String text;
  final List<String>? options;
  ChatMessage({required this.sender, required this.text, this.options});
}

class AgendaController extends ChangeNotifier {
  final ChatbotFirestoreRepository repository;

  // Controlador de texto para el campo de entrada
  final TextEditingController textController = TextEditingController();

  // Mensajes del chat
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // Todas las opciones obtenidas (slots) y paginado
  List<DateTime> _allOptions = [];
  final int _pageSize = 12;
  int _currentPage = 0;

  // --- getters públicos para que la UI calcule índices correctamente ---
  int get currentPageStartIndex => _currentPage * _pageSize;

  int get visibleOptionsCount {
    final remaining = _allOptions.length - currentPageStartIndex;
    if (remaining <= 0) return 0;
    return remaining < _pageSize ? remaining : _pageSize;
  }

  bool get hasMoreOptions =>
      (_currentPage + 1) * _pageSize < _allOptions.length;

  // Opciones actualmente visibles (slice de _allOptions)
  List<DateTime> get _visibleOptions =>
      _allOptions.skip(_currentPage * _pageSize).take(_pageSize).toList();

  bool _loading = false;
  bool get loading => _loading;

  // Usuario siempre considerado logeado
  bool _isLoggedIn = true;
  bool get isLoggedIn => _isLoggedIn;

  AgendaController({required this.repository}) {
    // Llamada asíncrona no bloqueante desde el constructor (arranca la conversación)
    startConversation();
  }

  void simulateLogin() {}

  void simulateLogout() {}

  void _addMessage(ChatMessage m) {
    _messages.add(m);
    notifyListeners();
  }

  Future<void> startConversation() async {
    _messages.clear();
    _addMessage(
      ChatMessage(
        sender: Sender.bot,
        text:
            '¡Hola! Soy el asistente de agendamiento de fumigaciones. Aquí puedes ver las franjas disponibles y reservar tu cita.',
      ),
    );
    await Future.delayed(const Duration(milliseconds: 400));
    await _showNextOptions();
  }

  Future<void> _showNextOptions() async {
    _setLoading(true);

    // Obtener slots para los próximos 30 días (ajustable)
    final slots = await repository.getAvailableSlots(days: 30);
    _allOptions = slots;

    _currentPage = 0;
    if (_allOptions.isEmpty) {
      _addMessage(
        ChatMessage(
          sender: Sender.bot,
          text:
              'Lo siento, no hay franjas disponibles en los próximos 30 días.',
        ),
      );
      _setLoading(false);
      return;
    }

    _emitOptionsMessage();
    _setLoading(false);
  }

  void _emitOptionsMessage() {
    final slice = _visibleOptions;
    final optionsText =
        slice.asMap().entries.map((e) {
          final idx = e.key + 1 + _currentPage * _pageSize; // número global
          final slot = e.value;
          final pretty = _formatSlot(slot);
          return '$idx) $pretty';
        }).toList();

    // Si hay más páginas, añadimos una opción de "Mostrar más" al final
    if ((_currentPage + 1) * _pageSize < _allOptions.length) {
      optionsText.add('Mostrar más opciones...');
    }

    // Crear el texto del mensaje con las opciones numeradas
    final messageText =
        'Estas son las franjas disponibles (próximos 30 días):\n\n'
        '${optionsText.join('\n')}\n\n'
        'Escribe el número de la opción que deseas seleccionar.';

    _addMessage(
      ChatMessage(
        sender: Sender.bot,
        text: messageText,
        options:
            optionsText, // Mantenemos las opciones para el procesamiento interno
      ),
    );
  }

  String _formatSlot(DateTime dt) {
    final local = dt.toLocal();
    final day =
        '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}';
    final hour = '${local.hour.toString().padLeft(2, '0')}:00';
    return '$day a las $hour';
  }

  /// El método que maneja la selección por número (1..N)
  Future<void> userSelectOption(int optionIndex) async {
    // Si seleccionó una de las opciones de la página actual o la opción "mostrar más"
    final globalIndex = optionIndex - 1; // convertir a 0-index
    final maxIndex = _allOptions.length - 1;

    // Si la opción corresponde al "Mostrar más" (última opción y quedan más)
    final slice = _visibleOptions;
    final isShowMore =
        (_currentPage + 1) * _pageSize < _allOptions.length &&
        optionIndex == ((_currentPage * _pageSize) + slice.length + 1);
    // Nota: arriba calculamos el índice de "Mostrar más" como el botón adicional al final

    // Si eligió "Mostrar más"
    if (isShowMore) {
      _addMessage(ChatMessage(sender: Sender.user, text: 'Mostrar más'));
      _currentPage++;
      _emitOptionsMessage();
      return;
    }

    // Validaciones: índice válido dentro de todas las opciones
    if (globalIndex < 0 || globalIndex > maxIndex) {
      _addMessage(
        ChatMessage(
          sender: Sender.bot,
          text: 'Opción inválida. Intenta otra vez.',
        ),
      );
      return;
    }

    final chosen = _allOptions[globalIndex];

    // Registrar el mensaje del usuario con el número que pulsó
    _addMessage(ChatMessage(sender: Sender.user, text: optionIndex.toString()));

    // Usuario considerado logeado: procedemos a reservar directamente

    // Si está logeado, procedemos a reservar
    _addMessage(
      ChatMessage(
        sender: Sender.bot,
        text: 'Perfecto, reservando ${_formatSlot(chosen)}...',
      ),
    );
    _setLoading(true);
    try {
      final appt = await repository.bookSlot(chosen);
      _addMessage(
        ChatMessage(
          sender: Sender.bot,
          text:
              '✅ ¡Listo! Tu cita quedó agendada para ${_formatSlot(appt.slot)}. Código: ${appt.id}',
        ),
      );
      // Remover la opción reservada de la lista global
      _allOptions.removeWhere(
        (s) => ChatbotFirestoreRepository.isSameSlot(s, chosen),
      );
      // Ajustar currentPage si hace falta
      final totalPages = (_allOptions.length / _pageSize).ceil();
      if (_currentPage >= totalPages && _currentPage > 0) {
        _currentPage = totalPages - 1;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      _addMessage(
        ChatMessage(sender: Sender.bot, text: '¿Necesitas otra cita?'),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      _emitOptionsMessage();
    } catch (e) {
      _addMessage(
        ChatMessage(
          sender: Sender.bot,
          text: 'Lo siento, no pude reservarlo: ${e.toString()}',
        ),
      );
      // refrescar opciones por seguridad
      _emitOptionsMessage();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void clearConversation() {
    _messages.clear();
    notifyListeners();
  }

  /// Procesa mensajes de texto del usuario
  Future<void> sendUserMessage(String message) async {
    // Limpiar el campo de texto
    textController.clear();

    // Agregar el mensaje del usuario al chat
    _addMessage(ChatMessage(sender: Sender.user, text: message));

    // Procesar el mensaje
    await _processUserMessage(message);
  }

  /// Interpreta el mensaje del usuario y ejecuta la acción correspondiente
  Future<void> _processUserMessage(String message) async {
    final lowerMessage = message.toLowerCase().trim();

    // Detectar si es un número (selección de opción)
    final numberMatch = RegExp(r'^(\d+)$').firstMatch(lowerMessage);
    if (numberMatch != null) {
      final optionNumber = int.parse(numberMatch.group(1)!);
      await userSelectOption(optionNumber);
      return;
    }

    // Detectar comandos específicos
    if (lowerMessage.contains('mostrar más') ||
        lowerMessage.contains('mostrar mas') ||
        lowerMessage.contains('siguiente')) {
      // Simular selección de "mostrar más"
      final lastMessage = _messages.last;
      if (lastMessage.options != null && lastMessage.options!.isNotEmpty) {
        // El índice de "mostrar más" es el último elemento de las opciones
        final showMoreIndex = lastMessage.options!.length;
        await userSelectOption(showMoreIndex);
      }
      return;
    }

    if (lowerMessage.contains('reiniciar') ||
        lowerMessage.contains('empezar')) {
      await startConversation();
      return;
    }

    if (lowerMessage.contains('limpiar') || lowerMessage.contains('borrar')) {
      clearConversation();
      return;
    }

    // Si no se reconoce el mensaje, mostrar ayuda
    _addMessage(
      ChatMessage(
        sender: Sender.bot,
        text:
            'No entiendo tu mensaje. Por favor escribe:\n'
            '• Un número para seleccionar una opción (ej: 1, 2, 3...)\n'
            '• "mostrar más" para ver más opciones\n'
            '• "reiniciar" para empezar de nuevo',
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
