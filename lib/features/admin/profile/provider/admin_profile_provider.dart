import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumi_click/features/admin/profile/data/admin_profile.dart';

final tecnicoProfileProvider = Provider<AdminProfile?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  // El rol puede venir de un custom claim, aquí se pone fijo para ejemplo
  return AdminProfile(
    uid: user.uid,
    nombre: user.displayName ?? '',
    correo: user.email ?? '',
    rol: 'admin',
  );
});
