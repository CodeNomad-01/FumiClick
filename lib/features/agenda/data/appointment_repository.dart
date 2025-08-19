import 'dart:math';
import 'appointment_model.dart';

/// Repositorio simple en memoria con protección contra double-booking.
/// La comprobación y el agregado del turno se hacen *sin await* para que
/// sean atómicos en el bucle de eventos de Dart.
class AppointmentRepository {
  final List<Appointment> _booked = [];

  /// Devuelve slots disponibles para los próximos [days] días.
  /// Cada día tiene horarios fijos: 09:00, 11:00, 14:00, 16:00
  Future<List<DateTime>> getAvailableSlots({int days = 7}) async {
    // Simula latencia de lectura (después de calcular)
    await Future.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    final slots = <DateTime>[];
    final candidateHours = [9, 11, 14, 16];

    for (int d = 0; d < days; d++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: d));
      for (var h in candidateHours) {
        final slot = DateTime(day.year, day.month, day.day, h);
        if (slot.isAfter(now)) {
          final alreadyBooked = _booked.any((b) => isSameSlot(b.slot, slot));
          if (!alreadyBooked) slots.add(slot);
        }
      }
    }

    slots.sort();
    return slots;
  }

  /// Reserva un slot. La comprobación y la inserción se hacen sin await para
  /// evitar condiciones de carrera entre llamadas concurrentes dentro de la app.
  Future<Appointment> bookSlot(DateTime slot, {String? customerName}) async {
    // ---- CRÍTICO: comprobación y push sin await ----
    // Validar que no esté reservado
    if (_booked.any((b) => isSameSlot(b.slot, slot))) {
      throw Exception('Slot already booked');
    }

    // Generar y agregar el appointment de forma síncrona (antes de cualquier await)
    final id = Random().nextInt(1000000).toString();
    final appt = Appointment(id: id, slot: slot, customerName: customerName);
    _booked.add(appt);

    // ---- Simular latencia AFTER COMMIT para UX ----
    await Future.delayed(const Duration(milliseconds: 300));
    return appt;
  }

  List<Appointment> getBookedAppointments() => List.unmodifiable(_booked);

  static bool isSameSlot(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day && a.hour == b.hour;
}
