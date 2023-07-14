
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'NotificationHelper.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

class NotificationConfig {
  static init() async {
    final notificationHelper = NotificationHelper();

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); //This work fine
    } catch (e, trace) {
      print('Error Running Notification in Background: $e');
    }

    //TODO: Foreground not work (the notification)
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          final body = ReceivedNotification(
            title: notification!.title!,
            body: notification!.body!,
          );
         if(Platform.isAndroid) {
           notificationHelper.showNormalNotification(
               body,message.data); //TODO: This is error when from `foreground`
         }

        }
      });
    } catch (e, trace) {
      print('Error Running Notification in Foreground: $e');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Andorid");
      print(message);
    });
  }
}

