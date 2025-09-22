import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final DateTime slot;
  final String? customerName;
  final String? contact;
  final String? address;
  final String? pestType;
  final String? establishmentType;
  final String status;

  Appointment({
    required this.id,
    required this.slot,
    this.customerName,
    this.contact,
    this.address,
    this.pestType,
    this.establishmentType,
    this.status = 'proximo',
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
      pestType: map['pestType'] as String?,
      establishmentType: map['establishmentType'] as String?,
      status: map['status'] as String? ?? 'proximo',
    );
  }

  Map<String, dynamic> toMap({required String userId, String? email}) {
    return {
      'userId': userId,
      'email': email,
      'slot': slot,
      'customerName': customerName,
      'contact': contact,
      'address': address,
      'pestType': pestType,
      'establishmentType': establishmentType,
      'status': status,
    };
  }

  Appointment copyWith({
    String? id,
    DateTime? slot,
    String? customerName,
    String? contact,
    String? address,
    String? pestType,
    String? establishmentType,
    String? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      customerName: customerName ?? this.customerName,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      pestType: pestType ?? this.pestType,
      establishmentType: establishmentType ?? this.establishmentType,
      status: status ?? this.status,
    );
  }
}
