import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/firestore_tecnico_appointment_repository.dart';
import '../data/models/admin_appointment.dart';

final tecnicoAppointmentsRepositoryProvider = Provider<FirestoreAdminAppointmentRepository>((ref) {
  return FirestoreAdminAppointmentRepository();
});

final tecnicoAppointmentsStreamProvider = StreamProvider<List<AdminAppointment>>((ref) {
  final repo = ref.watch(tecnicoAppointmentsRepositoryProvider);
  return repo.getCitas();
});
