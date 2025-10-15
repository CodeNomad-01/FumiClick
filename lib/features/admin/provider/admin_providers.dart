import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/firebase_technical_user_repository.dart';
import '../data/manage_technician_accounts.dart';
import '../data/technical_user_repository.dart';
import '../data/models/technical_user.dart';

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
