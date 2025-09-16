class UserProfile {
  final String userId;
  final String? name;
  final String? phone;
  final String? address;

  UserProfile({required this.userId, this.name, this.phone, this.address});

  factory UserProfile.fromMap(String userId, Map<String, dynamic> data) {
    return UserProfile(
      userId: userId,
      name: data['name'] as String?,
      phone: data['phone'] as String?,
      address: data['address'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone, 'address': address};
  }

  UserProfile copyWith({String? name, String? phone, String? address}) {
    return UserProfile(
      userId: userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
