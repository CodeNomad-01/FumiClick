import '../data/models/admin_appointment.dart';

abstract class AdminAppointmentRepository {
  Stream<List<AdminAppointment>> getCitasDelDia();
}
