import '../data/models/tecnico_appointment.dart';

abstract class TecnicoAppointmentRepository {
  Stream<List<TecnicoAppointment>> getCitasDelDia();
}
