import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String address;
  final String contact;
  final String? customerName;
  final String? email;
  final String? technicianEmail;
  final DateTime slot;
  final String status;
  final String? userId;

  Appointment({
    required this.id,
    required this.address,
    required this.contact,
    this.customerName,
    this.email,
    this.technicianEmail,
    required this.slot,
    required this.status,
    this.userId,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> map) {
    return Appointment(
      id: id,
      address: map['address'] as String? ?? '',
      contact: map['contact'] as String? ?? '',
      customerName: map['customerName'] as String?,
      email: map['email'] as String?,
      technicianEmail: map['technicianEmail'] as String?,
  slot: (map['slot'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] as String? ?? 'proximo',
      userId: map['userId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'contact': contact,
      'customerName': customerName,
      'email': email,
      'technicianEmail': technicianEmail,
      'slot': slot,
      'status': status,
      'userId': userId,
    };
  }
}
