import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/firestore_tecnico_appointment_repository.dart';
import '../data/models/tecnico_appointment.dart';

final tecnicoAppointmentsRepositoryProvider = Provider<FirestoreTecnicoAppointmentRepository>((ref) {
  return FirestoreTecnicoAppointmentRepository();
});

final tecnicoAppointmentsStreamProvider = StreamProvider<List<TecnicoAppointment>>((ref) {
  final repo = ref.watch(tecnicoAppointmentsRepositoryProvider);
  return repo.getCitas();
});
