import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/appointment.dart';
import 'appointment_repository.dart' as mem_repo;

class FirestoreAppointmentRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  final List<Appointment> _bookedCache = [];
  Stream<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  FirestoreAppointmentRepository({FirebaseFirestore? db, FirebaseAuth? auth})
    : _db = db ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance {
    _ensureSubscription();
  }

  void _ensureSubscription() {
    final user = _auth.currentUser;
    if (user == null) return;

    _subscription ??=
        _db
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('slot', descending: true)
            .snapshots();

    _subscription!.listen((snapshot) {
      _bookedCache
        ..clear()
        ..addAll(snapshot.docs.map((d) => Appointment.fromMap(d.id, d.data())));
    });
  }

  Stream<List<Appointment>> watchUserAppointments() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .orderBy('slot', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => Appointment.fromMap(d.id, d.data()))
                  .toList(),
        );
  }

  Stream<void> watchAllAppointments() {
    return _db.collection('appointments').snapshots().map((_) => null);
  }

  Future<List<DateTime>> getAvailableSlots({int days = 30}) async {
    final now = DateTime.now();
    final end = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: days + 1));

    final existingWithinRange =
        await _db
            .collection('appointments')
            .where('slot', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .where('slot', isLessThan: Timestamp.fromDate(end))
            .get();

    final takenSlots =
        existingWithinRange.docs
            .map((d) => (d.data()['slot'] as Timestamp).toDate())
            .map(_normalizeToHour)
            .toSet();

    final candidateHours = [9, 11, 14, 16];
    final slots = <DateTime>[];
    for (int d = 0; d < days; d++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: d));
      for (var h in candidateHours) {
        final slot = DateTime(day.year, day.month, day.day, h);
        if (slot.isAfter(now)) {
          if (!takenSlots.contains(slot)) slots.add(slot);
        }
      }
    }

    slots.sort();
    return slots;
  }

  Future<Appointment> bookAppointment(Appointment appointment) async {
    final slotNormalized = _normalizeToHour(appointment.slot);

    final collision =
        await _db
            .collection('appointments')
            .where('slot', isEqualTo: Timestamp.fromDate(slotNormalized))
            .limit(1)
            .get();
    if (collision.docs.isNotEmpty) {
      throw Exception('Este horario ya está reservado');
    }

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final data = appointment.toMap(userId: userId);
    data['slot'] = Timestamp.fromDate(slotNormalized);
    data['createdAt'] = FieldValue.serverTimestamp();

    final docRef = await _db.collection('appointments').add(data);

    final stored = appointment.copyWith(id: docRef.id, slot: slotNormalized);

    // best-effort cache update
    _bookedCache.add(stored);
    return stored;
  }

  Future<void> cancelAppointmentById(String appointmentId) async {
    final doc = _db.collection('appointments').doc(appointmentId);
    await doc.delete();
    _bookedCache.removeWhere((a) => a.id == appointmentId);
  }

  List<Appointment> getBookedAppointments() => List.unmodifiable(_bookedCache);

  static bool isSameSlot(DateTime a, DateTime b) =>
      mem_repo.AppointmentRepository.isSameSlot(a, b);

  DateTime _normalizeToHour(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day, dt.hour);
}
