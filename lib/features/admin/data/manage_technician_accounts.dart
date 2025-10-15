import 'technical_user_repository.dart';

class ManageTechnicianAccounts {
  final TechnicalUserRepository repo;
  ManageTechnicianAccounts(this.repo);

  /// Assign technician role by email. Returns a message code:
  /// 'success', 'not_found', 'is_admin'
  Future<String> assignRoleByEmail(String email) async {
    final user = await repo.findUserByEmail(email);
    if (user == null) return 'not_found';
    if (user.role == 'admin') return 'is_admin';
    if (user.role == 'tecnico') return 'already';
    await repo.updateUserRole(user.id, 'tecnico');
    return 'success';
  }

  Future<void> deactivateTechnician(String userId) async {
    await repo.updateUserRole(userId, 'usuario');
  }

  /// Update allowed fields for a technician: name, phone, address, role
  /// role can only be 'tecnico' or 'usuario'
  Future<String> updateTechnicianDetails(String userId, Map<String, dynamic> updates) async {
    // sanitize keys
    final allowed = {'name', 'phone', 'address', 'role'};
    final filtered = <String, dynamic>{};
    updates.forEach((k, v) {
      if (allowed.contains(k) && v != null) filtered[k] = v;
    });

    if (filtered.containsKey('role')) {
      final r = filtered['role']?.toString();
      if (r != 'tecnico' && r != 'usuario') return 'invalid_role';
    }

    if (filtered.isEmpty) return 'no_changes';

    await repo.updateTechnicianDetails(userId, filtered);
    return 'success';
  }
}
