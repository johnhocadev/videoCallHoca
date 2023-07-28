import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> handleBackgroundMessage(RemoteMessage message)async{
    print("Title: ${message.notification?.title}");
    print('BOdy: ${message.notification?.body}');
    print('Payload: ${message.data}');

  }



  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
     print("TOKEN: $fcmToken");
     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  }
}
