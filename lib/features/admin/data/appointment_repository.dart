import 'appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getUnassignedAppointments();
  Future<void> assignTechnicianToAppointment(String appointmentId, String technicianEmail);
  Future<List<Appointment>> getTechnicianAppointments(String technicianEmail);
}
