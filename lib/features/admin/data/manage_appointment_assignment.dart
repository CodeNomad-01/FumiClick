import 'appointment_repository.dart';

class ManageAppointmentAssignment {
  final AppointmentRepository repo;
  ManageAppointmentAssignment(this.repo);

  /// Assigns technicianEmail to an appointment. Returns 'success' or error codes.
  Future<String> assignTechnician(String appointmentId, String technicianEmail) async {
    // For now we just assign; more validation can be added (e.g., technician exists)
    try {
      await repo.assignTechnicianToAppointment(appointmentId, technicianEmail);
      return 'success';
    } catch (e) {
      return 'error';
    }
  }
}
