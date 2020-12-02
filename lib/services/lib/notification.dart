import 'package:flutter/foundation.dart';
import 'package:vendor/services/lib/db.dart';

class NotificationService {
  Future<void> addProviderFcmToken({
    @required int serviceProviderId,
    @required String token,
  }) async {
    final dbClient = DbClient('addFcmToken', serverPort: 3001);
    // {"serviceProviderId":1,"fcmToken":"dfdsfd"}
    await dbClient.post(
        body: {'serviceProviderId': serviceProviderId, 'fcmToken': token});
  }
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> addProviderFcmToken(
      {int serviceProviderId, String token}) async {}
}
