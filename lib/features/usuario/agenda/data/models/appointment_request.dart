
class AppointmentRequest {
  String? name;
  String? contact;
  String? address;
  DateTime? chosenSlot;
  String? establishmentType;
  String? pestType;

  AppointmentRequest({
    this.name,
    this.contact,
    this.address,
    this.chosenSlot,
    this.establishmentType,
    this.pestType,
  });

  bool validate() {
    return (name?.trim().isNotEmpty ?? false) &&
        (contact?.trim().isNotEmpty ?? false) &&
        chosenSlot != null &&
        (establishmentType?.trim().isNotEmpty ?? false) &&
        (pestType?.trim().isNotEmpty ?? false);
  }
}
