import 'package:flutter/material.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';

enum Sender { bot, user, system }

class ChatMessage {
  final Sender sender;
  final String text;
  final List<String>? options; // Opciones mostradas por el bot (1,2,3...)
  ChatMessage({
    required this.sender,
    required this.text,
    this.options,
  });
}

class AgendaController extends ChangeNotifier {
  final AppointmentRepository repository;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<DateTime> _currentOptions = [];

  bool _loading = false;
  bool get loading => _loading;

  AgendaController({required this.repository}) {
    startConversation();
  }

  void _addMessage(ChatMessage m) {
    _messages.add(m);
    notifyListeners();
  }

  Future<void> startConversation() async {
    _addMessage(ChatMessage(sender: Sender.bot, text: '¡Hola! Soy el asistente de agendamiento de fumigaciones. ¿Quieres agendar una cita? (responde con el número)'));
    await Future.delayed(const Duration(milliseconds: 600));
    await _showNextOptions();
  }

  Future<void> _showNextOptions() async {
    _setLoading(true);
    final slots = await repository.getAvailableSlots(days: 7);
    // Elegimos las primeras 4 opciones para mostrar
    _currentOptions = slots.take(4).toList();
    if (_currentOptions.isEmpty) {
      _addMessage(ChatMessage(sender: Sender.bot, text: 'Lo siento, no hay franjas disponibles por ahora.'));
      _setLoading(false);
      return;
    }

    final optionsText = _currentOptions.asMap().entries.map((e) {
      final idx = e.key + 1;
      final slot = e.value;
      final pretty = _formatSlot(slot);
      return '$idx) $pretty';
    }).toList();

    _addMessage(ChatMessage(sender: Sender.bot, text: 'Estas son las franjas disponibles:', options: optionsText));
    _setLoading(false);
  }

  String _formatSlot(DateTime dt) {
    final day = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
    final hour = '${dt.hour.toString().padLeft(2, '0')}:00';
    return '$day a las $hour';
  }

  void userSelectOption(int optionIndex) async {
    // optionIndex es 1..N de la UI
    final idx = optionIndex - 1;
    if (idx < 0 || idx >= _currentOptions.length) {
      _addMessage(ChatMessage(sender: Sender.bot, text: 'Opción inválida. Intenta otra vez.'));
      return;
    }

    final chosen = _currentOptions[idx];
    _addMessage(ChatMessage(sender: Sender.user, text: optionIndex.toString()));
    _addMessage(ChatMessage(sender: Sender.bot, text: 'Perfecto, reservando ${_formatSlot(chosen)}...'));
    _setLoading(true);
    try {
      final appt = await repository.bookSlot(chosen);
      _addMessage(ChatMessage(sender: Sender.bot, text: '✅ ¡Listo! Tu cita quedó agendada para ${_formatSlot(appt.slot)}. Código: ${appt.id}'));
      // Mostrar opciones siguientes (por si quiere otra cosa)
      await Future.delayed(const Duration(milliseconds: 700));
      _addMessage(ChatMessage(sender: Sender.bot, text: '¿Necesitas otra cita?'));
      await Future.delayed(const Duration(milliseconds: 400));
      await _showNextOptions();
    } catch (e) {
      _addMessage(ChatMessage(sender: Sender.bot, text: 'Lo siento, no pude reservarlo: ${e.toString()}'));
      await _showNextOptions();
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
