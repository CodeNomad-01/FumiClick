
class UserProfile {
  final String userId;
  final String? name;
  final String? phone;
  final String? address;
  final String? role;
  final String? email;

  UserProfile({required this.userId, this.name, this.phone, this.address, this.role, this.email});

  factory UserProfile.fromMap(String userId, Map<String, dynamic> data) {
    return UserProfile(
      userId: userId,
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      address: data['address'] as String?,
      role: data['role'] as String?,
      email: data['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'role': role,
      'email': email,
    };
  }

  UserProfile copyWith({String? name, String? phone, String? address, String? role, String? email}) {
    return UserProfile(
      userId: userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }
}
