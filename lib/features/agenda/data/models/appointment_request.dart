class AppointmentRequest {
  String? name;
  String? contact;
  String? address;
  DateTime? chosenSlot;

  AppointmentRequest({this.name, this.contact, this.address, this.chosenSlot});

  bool validate() {
    return (name?.trim().isNotEmpty ?? false) &&
        (contact?.trim().isNotEmpty ?? false) &&
        chosenSlot != null;
  }
}
