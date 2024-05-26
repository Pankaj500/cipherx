import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static final _firebasemessaging = FirebaseMessaging.instance;
  static Future init() async {
    await _firebasemessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // get device fcm token
    final token = _firebasemessaging.getToken();
    print('device token : $token');
  }
}
