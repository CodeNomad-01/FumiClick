import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fumi_click/features/admin/agenda/data/models/admin_appointment.dart';

class FirestoreAdminAppointmentRepository {
  final FirebaseFirestore _db;
  FirestoreAdminAppointmentRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// Obtiene todas las citas en tiempo real
  Stream<List<AdminAppointment>> getCitas() {
    return _db
        .collection('appointments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AdminAppointment.fromMap(doc.data(), doc.id))
            .toList()
          ..sort((a, b) => a.slot.compareTo(b.slot)));
  }
}
