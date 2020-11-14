import 'package:flutter/foundation.dart';
import 'package:vendor/services/lib/db.dart';

class NotificationService {
  Future<void> addVendorFcmToken({
    @required int customerId,
    @required String token,
  }) async {
    final dbClient = DbClient('addFcmToken');
    // {"serviceProviderId":1,"fcmToken":"dfdsfd"}
    await dbClient.post(body: {'customerId': customerId, 'fcmToken': token});
  }
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> addVendorFcmToken({int customerId, String token}) async {}
}
