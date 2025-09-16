import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/appointment.dart';
import '../data/models/appointment_request.dart';
import '../infrastructure/firestore_appointment_repository.dart';

final agendaControllerProvider = ChangeNotifierProvider<AgendaController>((
  ref,
) {
  return AgendaController(repository: FirestoreAppointmentRepository());
});

class AgendaController extends ChangeNotifier {
  final FirestoreAppointmentRepository repository;

  AgendaController({required this.repository}) {
    // cargar slots al inicio
    loadSlots();
    // escuchar cambios del usuario en Firestore para refrescar historial/contador
    repository.watchUserAppointments().listen((_) {
      notifyListeners();
    });
    // escuchar cambios globales para recomputar slots disponibles
    repository.watchAllAppointments().listen((_) {
      loadSlots();
    });
  }

  // UI state
  bool _loading = false;
  bool get loading => _loading;

  List<DateTime> _availableSlots = [];
  List<DateTime> get availableSlots => List.unmodifiable(_availableSlots);

  final AppointmentRequest request = AppointmentRequest();

  List<Appointment> get booked => repository.getBookedAppointments();

  int _pageSize = 12;
  int _currentPage = 0;
  int get currentPageStartIndex => _currentPage * _pageSize;
  int get visibleOptionsCount {
    final remaining = _availableSlots.length - currentPageStartIndex;
    if (remaining <= 0) return 0;
    return remaining < _pageSize ? remaining : _pageSize;
  }

  List<DateTime> get visibleSlots =>
      _availableSlots.skip(_currentPage * _pageSize).take(_pageSize).toList();

  bool get hasMoreOptions =>
      (_currentPage + 1) * _pageSize < _availableSlots.length;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  Future<void> loadSlots({int days = 30}) async {
    _setLoading(true);
    try {
      final slots = await repository.getAvailableSlots(days: days);
      _availableSlots = slots;
      _currentPage = 0;
    } finally {
      _setLoading(false);
    }
  }

  void updateName(String v) {
    request.name = v;
    notifyListeners();
  }

  void updateContact(String v) {
    request.contact = v;
    notifyListeners();
  }

  void updateAddress(String v) {
    request.address = v;
    notifyListeners();
  }

  void selectSlot(DateTime slot) {
    request.chosenSlot = slot;
    notifyListeners();
  }

  void showMore() {
    if (hasMoreOptions) {
      _currentPage++;
      notifyListeners();
    }
  }

  Future<void> submitForm() async {
    if (request.name == null ||
        request.contact == null ||
        request.address == null ||
        request.chosenSlot == null) {
      throw Exception('Todos los campos y la franja deben estar completos');
    }

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      slot: request.chosenSlot!,
      customerName: request.name,
      contact: request.contact,
      address: request.address,
    );

    await repository.bookAppointment(appointment);
    reset();
  }

  void reset() {
    request.name = null;
    request.contact = null;
    request.address = null;
    request.chosenSlot = null;
    notifyListeners();
  }
}
