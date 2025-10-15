import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumi_click/features/tecnico/agenda/data/models/tecnico_appointment.dart';

class FirestoreTecnicoAppointmentRepository {
  final FirebaseFirestore _db;
  FirestoreTecnicoAppointmentRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// Obtiene todas las citas en tiempo real
  Stream<List<TecnicoAppointment>> getCitas() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || email.isEmpty) {
      // No authenticated user, return empty stream
      return Stream.value(<TecnicoAppointment>[]);
    }
    return _db
        .collection('appointments')
        .where('technicianEmail', isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TecnicoAppointment.fromMap(doc.data(), doc.id))
            .toList()
          ..sort((a, b) => a.slot.compareTo(b.slot)));
  }
}
