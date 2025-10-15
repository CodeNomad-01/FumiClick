import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';
import '../infrastructure/firestore_tecnico_appointment_repository.dart';
import '../data/models/tecnico_appointment.dart';

final tecnicoAppointmentsRepositoryProvider = Provider<FirestoreTecnicoAppointmentRepository>((ref) {
  return FirestoreTecnicoAppointmentRepository();
});

final tecnicoAppointmentsStreamProvider = StreamProvider<List<TecnicoAppointment>>((ref) {
  final repo = ref.watch(tecnicoAppointmentsRepositoryProvider);
  // Watch auth state so this provider rebuilds when user logs in/out
  final userAsync = ref.watch(userAuthProvider);
  final email = userAsync.value?.email;
  if (email == null || email.isEmpty) {
    return Stream.value(<TecnicoAppointment>[]);
  }
  return repo.getCitas();
});
