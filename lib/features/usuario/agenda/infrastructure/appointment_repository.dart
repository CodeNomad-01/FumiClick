import 'dart:math';
import '../data/models/appointment.dart';

class AppointmentRepository {
  final List<Appointment> _booked = [];

  // Slots fijos por día: 09, 11, 14, 16
  Future<List<DateTime>> getAvailableSlots({int days = 30}) async {
    await Future.delayed(const Duration(milliseconds: 150));
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

  Future<Appointment> bookAppointment(Appointment appointment) async {
    if (_booked.any((b) => isSameSlot(b.slot, appointment.slot))) {
      throw Exception('Este horario ya está reservado');
    }

    // Si el id no viene asignado, generar uno aleatorio
    final appt = Appointment(
      id: appointment.id.isNotEmpty
          ? appointment.id
          : Random().nextInt(1000000).toString(),
      slot: appointment.slot,
      customerName: appointment.customerName,
      contact: appointment.contact,
      address: appointment.address,
    );

    _booked.add(appt);

    // Simula latencia
    await Future.delayed(const Duration(milliseconds: 250));
    return appt;
  }

  List<Appointment> getBookedAppointments() => List.unmodifiable(_booked);

  static bool isSameSlot(DateTime a, DateTime b) =>
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day &&
      a.hour == b.hour;
}
