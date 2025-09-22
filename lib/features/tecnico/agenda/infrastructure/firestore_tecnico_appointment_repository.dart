import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumi_click/features/tecnico/agenda/data/models/tecnico_appointment.dart';

class FirestoreTecnicoAppointmentRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreTecnicoAppointmentRepository({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Obtiene todas las citas en tiempo real
  Stream<List<TecnicoAppointment>> getCitas() {
    return _db
        .collection('appointments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TecnicoAppointment.fromMap(doc.data(), doc.id))
            .toList()
          ..sort((a, b) => a.slot.compareTo(b.slot)));
  }
}
