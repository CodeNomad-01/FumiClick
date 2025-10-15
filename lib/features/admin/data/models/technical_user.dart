class TechnicalUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String role;

  TechnicalUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
  });

  factory TechnicalUser.fromMap(String id, Map<String, dynamic> map) {
    return TechnicalUser(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      role: map['role'] as String? ?? 'usuario',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }

  TechnicalUser copyWith({
    String? name,
    String? phone,
    String? address,
    String? role,
  }) {
    return TechnicalUser(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }
}
