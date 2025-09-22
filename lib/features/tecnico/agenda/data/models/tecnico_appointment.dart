import 'package:cloud_firestore/cloud_firestore.dart';
class TecnicoAppointment {
  final String id;
  final String clienteNombre;
  final String direccion;
  final DateTime slot;
  final String tipoServicio;
  final String? estado;

  TecnicoAppointment({
    required this.id,
    required this.clienteNombre,
    required this.direccion,
    required this.slot,
    required this.tipoServicio,
    this.estado,
  });

  factory TecnicoAppointment.fromMap(Map<String, dynamic> map, String id) {
    return TecnicoAppointment(
      id: id,
      clienteNombre: map['customerName'] ?? '',
      direccion: map['address'] ?? '',
      slot: (map['slot'] as Timestamp).toDate(),
      tipoServicio: map['pestType'] ?? '',
      estado: map['estado'] as String?,
    );
  }
}
