import 'package:shared/services/db.dart';

class NotificationService {
  Future<void> addProviderFcmToken({
    required int serviceProviderId,
    required String token,
  }) async {
    final dbClient = DbClient('addFcmToken', serverPort: 3001);
    // {"serviceProviderId":1,"fcmToken":"dfdsfd"}
    await dbClient.post(
        body: {'serviceProviderId': serviceProviderId, 'fcmToken': token});
  }

  Future<void> addCustomerFcmToken({
    required int customerId,
    required String token,
  }) async {
    final dbClient = DbClient('addFcmToken');
    // {"serviceProviderId":1,"fcmToken":"dfdsfd"}
    await dbClient.post(body: {'customerId': customerId, 'fcmToken': token});
  }
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> addProviderFcmToken(
      {required int serviceProviderId, required String token}) async {}

  @override
  Future<void> addCustomerFcmToken(
      {required int customerId, required String token}) async {}
}
