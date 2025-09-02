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
}