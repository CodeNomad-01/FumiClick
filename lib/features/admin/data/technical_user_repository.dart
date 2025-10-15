import '../data/models/technical_user.dart';

abstract class TechnicalUserRepository {
  Future<List<TechnicalUser>> getAllTechnicians();
  Future<TechnicalUser?> findUserByEmail(String email);
  Future<void> updateUserRole(String userId, String newRole);
  /// Updates only allowed fields: name, phone, address, role
  Future<void> updateTechnicianDetails(String userId, Map<String, dynamic> updates);
}
