import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final DateTime slot;
  final String? customerName;
  final String? contact;
  final String? address;

  Appointment({
    required this.id,
    required this.slot,
    this.customerName,
    this.contact,
    this.address,
  });

  factory Appointment.fromMap(String id, Map<String, dynamic> map) {
    final dynamic slotValue = map['slot'];
    final DateTime slotDateTime =
        slotValue is Timestamp
            ? slotValue.toDate()
            : slotValue is DateTime
            ? slotValue
            : DateTime.fromMillisecondsSinceEpoch(0);
    return Appointment(
      id: id,
      slot: slotDateTime,
      customerName: map['customerName'] as String?,
      contact: map['contact'] as String?,
      address: map['address'] as String?,
    );
  }

  Map<String, dynamic> toMap({required String userId}) {
    return {
      'userId': userId,
      'slot': slot,
      'customerName': customerName,
      'contact': contact,
      'address': address,
    };
  }

  Appointment copyWith({
    String? id,
    DateTime? slot,
    String? customerName,
    String? contact,
    String? address,
  }) {
    return Appointment(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      customerName: customerName ?? this.customerName,
      contact: contact ?? this.contact,
      address: address ?? this.address,
    );
  }
}
