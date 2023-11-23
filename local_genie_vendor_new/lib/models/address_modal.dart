class AddressI {
  final String? id;
  final String line;
  final String area;
  final String city;
  final String pincode;
  final String contact;
  final String state;
  final String country;
  final bool primary;

  AddressI({
    this.line = "",
    this.area = "",
    this.id = "",
    this.pincode = "",
    this.state = "",
    this.country = "",
    this.city = "",
    this.contact = "",
    this.primary = false,
  });

  AddressI.fromJson(Map<String, dynamic> json)
      : this(
          line: json['line'] ?? "",
          area: json['area'] ?? "",
          id: json['_id'] ?? "",
          pincode: json['pincode'] ?? "",
          city: json['city'] ?? "",
          state: json['state'] ?? "",
          contact: json['contact'] ?? "",
          country: json['country'] ?? "",
          primary: json['primary'] ?? false,
        );

  Map<String, dynamic> toJson() => {
        'line': line,
        'area': area,
        '_id': id,
        'pincode': pincode,
        'city': city,
        'state': state,
        'contact': contact,
        'country': country,
        'primary': primary,
      };

  AddressI copiedWithPrimary(bool primary) => AddressI(
        line: line,
        area: area,
        id: id,
        pincode: pincode,
        city: city,
        state: state,
        country: country,
        primary: primary,
        contact: contact,
      );

  @override
  String toString() {
    return 'AddressI(id: $id line: $line area: $area city: $city pincode: $pincode state: $state country: $country contact: $contact primary: $primary)';
  }
}
