import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumi_click/features/agenda/data/models/appointment.dart'
    as agenda;
import 'package:fumi_click/features/agenda/infrastructure/appointment_repository.dart'
    as mem_repo;

class ChatbotFirestoreRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ChatbotFirestoreRepository({FirebaseFirestore? db, FirebaseAuth? auth})
    : _db = db ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

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
            .map((dt) => DateTime(dt.year, dt.month, dt.day, dt.hour))
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

  Future<agenda.Appointment> bookSlot(
    DateTime slot, {
    String? customerName,
  }) async {
    final normalized = DateTime(slot.year, slot.month, slot.day, slot.hour);

    final collision =
        await _db
            .collection('appointments')
            .where('slot', isEqualTo: Timestamp.fromDate(normalized))
            .limit(1)
            .get();
    if (collision.docs.isNotEmpty) {
      throw Exception('Slot already booked');
    }

    final user = _auth.currentUser;
    final userId = user?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    final inferredName =
        customerName ??
        (user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!
            : (user?.email != null
                ? user!.email!.split('@').first
                : 'Usuario'));

    final appt = agenda.Appointment(
      id: '',
      slot: normalized,
      customerName: inferredName,
    );

    final data = appt.toMap(userId: userId);
    data['slot'] = Timestamp.fromDate(normalized);
    data['createdAt'] = FieldValue.serverTimestamp();

    final docRef = await _db.collection('appointments').add(data);

    return appt.copyWith(id: docRef.id);
  }

  static bool isSameSlot(DateTime a, DateTime b) =>
      mem_repo.AppointmentRepository.isSameSlot(a, b);
}
