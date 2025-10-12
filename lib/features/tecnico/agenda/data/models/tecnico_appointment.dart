import 'package:cloud_firestore/cloud_firestore.dart';

class TecnicoAppointment {
  final String id;
  final String clienteNombre;
  final String contact;
  final String direccion;
  final DateTime slot;
  final String tipoServicio;
  final String? estado;
  final String? observaciones;
  final String? hallazgos;
  final DateTime? fechaObservaciones;

  TecnicoAppointment({
    required this.id,
    required this.clienteNombre,
    required this.direccion,
    required this.slot,
    required this.tipoServicio,
    required this.contact,
    this.estado,
    this.observaciones,
    this.hallazgos,
    this.fechaObservaciones,
  });

  factory TecnicoAppointment.fromMap(Map<String, dynamic> map, String id) {
    return TecnicoAppointment(
      id: id,
      clienteNombre: map['customerName'] ?? '',
      direccion: map['address'] ?? '',
      slot: (map['slot'] as Timestamp).toDate(),
      tipoServicio: map['pestType'] ?? '',
      contact: map['contact'] ?? '',
      estado: map['estado'] as String?,
      observaciones: map['observaciones'] as String?,
      hallazgos: map['hallazgos'] as String?,
      fechaObservaciones:
          map['fechaObservaciones'] != null
              ? (map['fechaObservaciones'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': clienteNombre,
      'address': direccion,
      'slot': Timestamp.fromDate(slot),
      'pestType': tipoServicio,
      'contact': contact,
      'estado': estado,
      'observaciones': observaciones,
      'hallazgos': hallazgos,
      'fechaObservaciones':
          fechaObservaciones != null
              ? Timestamp.fromDate(fechaObservaciones!)
              : null,
    };
  }
}
