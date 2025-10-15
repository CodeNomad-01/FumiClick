import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/technical_user.dart';
import '../data/technical_user_repository.dart';

class FirebaseTechnicalUserRepository implements TechnicalUserRepository {
  final FirebaseFirestore _db;
  FirebaseTechnicalUserRepository({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TechnicalUser>> getAllTechnicians() async {
    final snap = await _db.collection('users').where('role', isEqualTo: 'tecnico').get();
    return snap.docs.map((d) => TechnicalUser.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<TechnicalUser?> findUserByEmail(String email) async {
    final snap = await _db.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (snap.docs.isEmpty) return null;
    final d = snap.docs.first;
    return TechnicalUser.fromMap(d.id, d.data());
  }

  @override
  Future<void> updateUserRole(String userId, String newRole) async {
    await _db.collection('users').doc(userId).update({'role': newRole});
  }

  @override
  Future<void> updateTechnicianDetails(String userId, Map<String, dynamic> updates) async {
    // only allow these fields
    final allowed = {'name', 'phone', 'address', 'role'};
    final filtered = <String, dynamic>{};
    updates.forEach((k, v) {
      if (allowed.contains(k)) filtered[k] = v;
    });
    if (filtered.isEmpty) return;
    await _db.collection('users').doc(userId).update(filtered);
  }
}
