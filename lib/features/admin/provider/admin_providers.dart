import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/firebase_technical_user_repository.dart';
import '../data/manage_technician_accounts.dart';
import '../data/technical_user_repository.dart';
import '../data/models/technical_user.dart';
import '../data/appointment.dart';
import '../infrastructure/firebase_appointment_repository.dart';
import '../data/appointment_repository.dart';
import '../data/manage_appointment_assignment.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final technicalUserRepositoryProvider = Provider<TechnicalUserRepository>((ref) {
  final db = ref.read(firebaseFirestoreProvider);
  return FirebaseTechnicalUserRepository(firestore: db);
});

final manageTechnicianAccountsProvider = Provider<ManageTechnicianAccounts>((ref) {
  final repo = ref.read(technicalUserRepositoryProvider);
  return ManageTechnicianAccounts(repo);
});

final techniciansListProvider = FutureProvider<List<TechnicalUser>>((ref) async {
  final repo = ref.read(technicalUserRepositoryProvider);
  return repo.getAllTechnicians();
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final db = ref.read(firebaseFirestoreProvider);
  return FirebaseAppointmentRepository(firestore: db);
});

final manageAppointmentAssignmentProvider = Provider<ManageAppointmentAssignment>((ref) {
  final repo = ref.read(appointmentRepositoryProvider);
  return ManageAppointmentAssignment(repo);
});

final unassignedAppointmentsProvider = FutureProvider.family<List<Appointment>, String?>((ref, search) async {
  final repo = ref.read(appointmentRepositoryProvider);
  final all = await repo.getUnassignedAppointments();
  if (search == null || search.trim().isEmpty) return all;
  final q = search.trim().toLowerCase();
  return all.where((a) => (a.customerName ?? '').toLowerCase().contains(q) || a.address.toLowerCase().contains(q)).toList();
});

final technicianAppointmentsProvider = FutureProvider.family<List<Appointment>, String>((ref, technicianEmail) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getTechnicianAppointments(technicianEmail);
});
