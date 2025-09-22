import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_profile.dart';

class UserProfileRepository {
  Future<UserProfile?> loadUserProfileByEmail(String email) async {
    final query = await _db.collection('users').where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    return UserProfile.fromMap(doc.id, doc.data());
  }
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  UserProfileRepository({FirebaseFirestore? db, FirebaseAuth? auth})
    : _db = db ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Stream<UserProfile?> watchCurrentUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return const Stream<UserProfile?>.empty();
    final doc = _db.collection('users').doc(user.uid);
    return doc.snapshots().map((snap) {
      if (!snap.exists) return UserProfile(userId: user.uid);
      return UserProfile.fromMap(snap.id, snap.data() as Map<String, dynamic>);
    });
  }

  Future<UserProfile?> loadCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _db.collection('users').doc(user.uid).get();
    if (!snap.exists) return UserProfile(userId: user.uid);
    return UserProfile.fromMap(snap.id, snap.data() as Map<String, dynamic>);
  }

  Future<void> saveCurrentUserProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');
    await _db
        .collection('users')
        .doc(user.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }
}
