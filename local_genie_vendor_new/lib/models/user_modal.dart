import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserI {
  final String serviceProviderId;
  final String businessId;
  final String businessIdURL;
  final String serviceProviderName;
  final String address;
  final String pinCode;
  final String mobileNumber;
  final String serviceProviderIconURL;
  final List<String> fcmTokens;

  UserI({
    required this.serviceProviderName,
    required this.businessId,
    this.serviceProviderId = "",
    this.serviceProviderIconURL = "",
    this.businessIdURL = "",
    this.address = "",
    this.pinCode = "",
    this.mobileNumber = "",
    this.fcmTokens = const [],
  });

  UserI.fromJson(Map<String, dynamic> json)
      : this(
          serviceProviderId: (json['serviceProviderId'] ?? "").toString(),
          serviceProviderName: json['serviceProviderName'] ?? "",
          serviceProviderIconURL:
              "${dotenv.get("IMAGE_HOST")}${json['serviceProviderIconURL'] ?? ""}",
          businessIdURL:
              "${dotenv.get("IMAGE_HOST")}qrcodes/${json['businessId']}.png",
          businessId: json['businessId'] ?? "",
          address: json['address'] ?? "",
          pinCode: (json['pinCode'] ?? "").toString(),
          mobileNumber: (json['mobileNumber'] ?? "").toString(),
          fcmTokens:
              json['fcmTokens'] != null ? json['fcmTokens'].cast<String>() : [],
        );

  @override
  String toString() {
    return 'UserI(serviceProviderId: $serviceProviderId serviceProviderName: $serviceProviderName businessId: $businessId serviceProviderIconURL: $serviceProviderIconURL address: $address address: $address pinCode: $pinCode mobileNumber: $mobileNumber fcmTokens: $fcmTokens)';
  }
}
