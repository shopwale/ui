import 'package:flutter/foundation.dart';

/// Details about a service provider.
class Provider {
  final int id;
  final String name;
  final int mobileNumber;
  final int pinCode;
  final String address;

  Provider({
    @required this.id,
    @required this.name,
    this.mobileNumber,
    this.pinCode,
    this.address,
  });

  Provider.fromJson(Map<String, dynamic> json)
      : this(
          id: json['serviceProviderId'],
          name: json['serviceProviderName'],
          // mobileNumber: json['serviceProviderMobileNumber'],
          // pinCode: json['serviceProviderPinCode'],
          address: json['serviceProviderAddress'],
        );
}
