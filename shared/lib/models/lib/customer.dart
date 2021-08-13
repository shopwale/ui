import 'package:meta/meta.dart';

class Customer {
  final int id;
  final int mobileNumber;
  final String customerName;
  final int pinCode;
  final String address;
  final List<String> tokens;

  Customer({
    @required this.id,
    @required this.mobileNumber,
    @required this.customerName,
    @required this.pinCode,
    @required this.address,
    this.tokens = const [],
  });

  Customer.fromJson(Map<String, dynamic> json)
      : this(
          id: json['customerId'],
          mobileNumber: json['mobileNumber'],
          customerName: json['customerName'],
          pinCode: json['pinCode'],
          address: json['address'],
          tokens: List<String>.from(json['fcmTokens'] ?? []),
        );
}
