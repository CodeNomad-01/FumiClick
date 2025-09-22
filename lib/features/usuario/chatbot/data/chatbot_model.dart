class Appointment {
  final String id;
  final DateTime slot;
  final String? customerName;

  Appointment({
    required this.id,
    required this.slot,
    this.customerName,
  });
}
