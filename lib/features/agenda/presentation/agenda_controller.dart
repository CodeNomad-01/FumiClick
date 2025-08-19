import 'package:flutter/material.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';

enum Sender { bot, user, system }

class ChatMessage {
  final Sender sender;
  final String text;
  final List<String>? options;
  ChatMessage({required this.sender, required this.text, this.options});
}

class AgendaController extends ChangeNotifier {
  final AppointmentRepository repository;

  // Mensajes del chat
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // Todas las opciones obtenidas (slots) y paginado
  List<DateTime> _allOptions = [];
  int _pageSize = 12;
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

  // Simulación de login (para evitar reservar si no hay sesión)
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AgendaController({required this.repository}) {
    startConversation();
  }

  void simulateLogin() {
    _isLoggedIn = true;
    _addMessage(
      ChatMessage(
        sender: Sender.system,
        text: 'Simulación: usuario iniciado sesión.',
      ),
    );
    notifyListeners();
  }

  void simulateLogout() {
    _isLoggedIn = false;
    _addMessage(
      ChatMessage(
        sender: Sender.system,
        text: 'Simulación: usuario cerrado sesión.',
      ),
    );
    notifyListeners();
  }

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
            '¡Hola! Soy el asistente de agendamiento de fumigaciones. Aquí puedes ver las franjas disponibles. Para reservar debes iniciar sesión.',
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

    _addMessage(
      ChatMessage(
        sender: Sender.bot,
        text: 'Estas son las franjas disponibles (próximos 30 días):',
        options: optionsText,
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
  void userSelectOption(int optionIndex) async {
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

    // Si no está logeado, NO se reserva: mostramos mensaje informativo.
    if (!_isLoggedIn) {
      _addMessage(
        ChatMessage(
          sender: Sender.bot,
          text:
              'Para reservar necesitas iniciar sesión. Por ahora solo puedes consultar las franjas (cotización).',
        ),
      );
      // (Opcional) podríamos dar la opción de simular login aquí, pero lo dejamos en la UI.
      return;
    }

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
        (s) => AppointmentRepository.isSameSlot(s, chosen),
      );
      // Ajustar currentPage si hace falta
      final totalPages = (_allOptions.length / _pageSize).ceil();
      if (_currentPage >= totalPages && _currentPage > 0)
        _currentPage = totalPages - 1;
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
}
