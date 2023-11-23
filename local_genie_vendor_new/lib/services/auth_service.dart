import 'dart:convert';

import 'package:local_genie_vendor/api_properties.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/user_modal.dart';
import 'package:local_genie_vendor/services/http_service.dart';
import 'package:local_genie_vendor/services/secure_storage_service.dart';

Future<bool> login(String username) async {
  try {
    // final httpService = HttpService(LOGIN);

    // final data = await httpService.post(body: {'username': username});

    // if (data != null) {
    //   final secureStorage = SecureStorage();
    //   await secureStorage.writeSecureData(cookieKey, headers[cookieKey]);

    return true;
    // } else {
    //   throw {"message": "Not success"}.toString();
    // }
  } catch (e) {
    throw e;
    // throw jsonEncode(e);
  }
}

Future<bool> sendOtp(String username) async {
  try {
    // final httpService = HttpService(SEND_OTP);

    // final data = await httpService.post(body: {'username': username});
    // if (data != null) {
    return true;
    // } else {
    //   throw {"message": "Not success"};
    // }
  } catch (e) {
    throw e;
  }
}

Future<bool> verifyOtp(String username, String otp) async {
  try {
    // final httpService = HttpService(VERIFY_OTP);

    // final data =
    //     await httpService.patch(body: {'username': username, 'otp': otp});

    // if (data != null) {
    return true;
    // } else {
    //   throw {"message": "Not success"};
    // }
  } catch (e) {
    throw e;
  }
}

Future register(
    {required String username,
    required String password,
    required String lastName,
    required String firstName}) async {
  try {
    final httpService = HttpService(REGISTER, 1);

    final data = await httpService.post(body: {
      'username': username,
      'password': password,
      'last_name': lastName,
      'first_name': firstName
    });

    if (data != null) {
      final secureStorage = SecureStorage();
      await secureStorage.writeSecureData(cookieKey, headers[cookieKey]);

      return true;
    } else {
      throw {"message": "Not success"};
    }
  } catch (e) {
    throw e;
  }
}

Future<bool> logout() async {
  try {
    final httpService = HttpService(LOGOUT, 1);

    final data = await httpService.post(body: {});

    if (data != null) {
      final secureStorage = SecureStorage();

      await secureStorage.deleteSecureData(cookieKey);
      await secureStorage.deleteSecureData(userNameKey);

      return true;
    } else {
      throw {"message": "Not success"}.toString();
    }
  } catch (e) {
    throw jsonEncode(e);
  }
}

Future<UserI> getServiceProvider(String serviceProviderId) async {
  try {
    final httpService = HttpService(SERVICE_PROVIDER_DETAILS, 2);

    final data = await httpService
        .get(queryParams: {'serviceProviderId': serviceProviderId});

    print(data.toString());

    return UserI.fromJson(data);
  } catch (e) {
    print(e.toString());
    throw e;
    // throw jsonEncode(e);
  }
}
