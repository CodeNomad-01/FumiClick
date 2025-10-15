import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/appointment.dart';
import '../data/appointment_repository.dart';

class FirebaseAppointmentRepository implements AppointmentRepository {
  final FirebaseFirestore _db;
  FirebaseAppointmentRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Appointment>> getUnassignedAppointments() async {
    // Firestore doesn't support 'field missing' in queries directly. Query a broad set
    // and filter client-side for documents where 'technicianEmail' is null/empty/missing.
    final snap = await _db.collection('appointments').get();
    final list = <Appointment>[];
    for (final d in snap.docs) {
      final data = d.data();
      final tech = data['technicianEmail'];
      if (tech == null || (tech is String && tech.trim().isEmpty)) {
        list.add(Appointment.fromMap(d.id, data));
      }
    }
    return list;
  }

  @override
  Future<void> assignTechnicianToAppointment(String appointmentId, String technicianEmail) async {
    final docRef = _db.collection('appointments').doc(appointmentId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) throw Exception('Appointment not found');
      // assign technicianEmail and optionally update status
      tx.update(docRef, {'technicianEmail': technicianEmail, 'status': 'assigned'});
    });
  }

  @override
  Future<List<Appointment>> getTechnicianAppointments(String technicianEmail) async {
    final snap = await _db.collection('appointments')
        .where('technicianEmail', isEqualTo: technicianEmail)
        .get();
    return snap.docs.map((d) => Appointment.fromMap(d.id, d.data())).toList();
  }
}
