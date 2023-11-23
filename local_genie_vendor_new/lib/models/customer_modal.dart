class CustomerI {
  final String customerId;
  final String customerName;
  final String address;
  final String pinCode;
  final String mobileNumber;
  final int status;

  CustomerI({
    required this.customerName,
    this.customerId = "",
    this.address = "",
    this.pinCode = "",
    this.mobileNumber = "",
    this.status = 1,
  });

  CustomerI.fromJson(Map<String, dynamic> json)
      : this(
          customerId: (json['customerId'] ?? "").toString(),
          customerName: json['customerName'] ?? "",
          address: json['address'] ?? "",
          pinCode: (json['pinCode'] ?? "").toString(),
          mobileNumber: (json['mobileNumber'] ?? "").toString(),
          status: int.parse(json['status'].toString()),
        );

  @override
  String toString() {
    return 'CustomerI(customerName: $customerName customerName: $customerName address: $address address: $address pinCode: $pinCode mobileNumber: $mobileNumber status: $status)';
  }
}
