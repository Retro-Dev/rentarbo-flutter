
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

import 'Controllers/ChatScreen.dart';
import 'Controllers/Dashboard.dart';
import 'Controllers/DisputeDetailsMain.dart';
import 'Controllers/RentRequestDetail.dart';
import 'Controllers/Reviews.dart';
import 'Models/Ads.dart';
import 'Models/PushNoti.dart';
import 'Models/RentalBooking.Dart.dart';
import 'Utils/Ads_services.dart';
import 'Utils/BaseModel.dart';
import 'Utils/BookingAds.dart';
import 'Utils/Sell_Services.dart';
import 'Utils/utils.dart';
import 'View/views.dart';
import 'main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> selectNotificationSubject =
BehaviorSubject<String?>();


class NotificationHelper {
  /// Singleton pattern
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
    _init();
  }

  factory NotificationHelper() =>
      _instance ?? NotificationHelper._internal();

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _init() async {
    await _setupLocalNotification();
    await _setupFcm();

  }

  Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    final notificationHelper = NotificationHelper();

    final body = ReceivedNotification(
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
    );

    await notificationHelper.showNormalNotification(body , message.data); //TODO: This is not error when from `background`
  }

  Future<void> _setupLocalNotification() async {
    const channel = AndroidNotificationChannel(
      NotificationChannel.channelId,
      NotificationChannel.channelName,
      description: NotificationChannel.channelDesc,
      importance: Importance.max,
    );

    /// Initialization Settings for Android
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Initialization Settings for iOS
    const initializationSettingsIOS = DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true,requestAlertPermission: true,requestCriticalPermission: true);



    // IOSInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true);

    /// InitializationSettings for initializing settings for both platforms
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );


    //
    // _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);


    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,onDidReceiveNotificationResponse: onDidReceiveNotificationResponse );


    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {



    if (notificationResponse.payload != null) {
      print("clicked notification android");

      debugPrint('notification payload:${notificationResponse.id}');
      debugPrint('notification payload:${notificationResponse.payload}');
      debugPrint('notification payload:${notificationResponse.actionId}');
      debugPrint('notification payload:${notificationResponse.notificationResponseType}');


      print(notificationResponse.payload?.split("custom_data:")[1].replaceAll("}}", "}"));
      var result = jsonDecode(notificationResponse.payload?.split("custom_data:")[1].replaceAll("}}", "}") ?? "");
     print("--------------result------------");
      print(result);
      final pushNoti = CustomData.fromJson(result);
      print(pushNoti.slug);
      print(pushNoti.product_type);
      print(pushNoti.productId);


      if (pushNoti.type == "booking") {

        Observable.instance.notifyObservers([
          "_RentalRequestContentViewState",
        ], notifyName : "custom_data",map: pushNoti.toJson());

        ///Observable.instance.notifyObservers(null);
        Observable.instance.notifyObservers([
          "_RentalRequestDetailState",
        ], notifyName: "custom_data", map: pushNoti.toJson());

        showLoading();
        getRentalBookingDetails(
            slug: pushNoti.slug, onSuccess: (data) {
          // RentalBookingDetails
          // rentalBookingDetails = data;
          // widget._rentalBookingDetails = data;
          AdsObj? adsobj;
          RentalBookingdatum? rentalDetails;
          adsobj = AdsObj.fromJson({ "id": data.data?.product?.id ,
            "userId": data.data?.product?.userId,
            "categoryId": data.data?.product?.categoryId,
            "name": data.data?.product?.name,
            "slug": data.data?.product?.slug,
            "description": data.data?.product?.description,
            "tags": List<String>.from(data.data!.product!.tags!.map((x) => x)),
            "rentType": data.data?.product?.rentType,
            "rentCharges": data.data?.product?.rentCharges,
            "sellPrice": data.data?.product?.sellPrice,
            "pickUpLocationAddress": data.data?.product?.pickUpLocationAddress,
            "pickupLat": data.data?.product?.pickupLat,
            "pickupLng": data.data?.product?.pickupLng,
            "dropLocationAddress": data.data?.product?.dropLocationAddress,
            "dropLat": data.data?.product?.dropLat,
            "dropLng": data.data?.product?.dropLng,
            "ssn": data.data?.product?.ssn,
            "idCard": data.data?.product?.idCard,
            "drivingLicense": data.data?.product?.drivingLicense,
            "hostingDemos": data.data?.product?.hostingDemos,
            "rating":data.data?.product?.rating,
            "reviews": data.data?.product?.reviews,
            "isSell": data.data?.product?.isSell,
            "isRent": data.data?.product?.isRent,
            "sellStatus": data.data?.product?.sellStatus,
            "pendingRequest": data.data?.product?.pendingRequest,
            "category": data.data!.product!.category!.toJson(),
            "owner":data.data!.product!.category!.toJson(),
            "media": data.data!.product!.media!.map((x) => x.toJson())});
          rentalDetails = RentalBookingdatum.fromJson(data.data!.toJson());

          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Dashboard.route, (route) => false);

          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => RentalRequestDetail(
                      "Requests",adsobj ,navigatorKey , rentalDetails, data , null)));
          hideLoading();
        }, onError: (error) {
          hideLoading();
          showToast(error);
        }, jsonData: {});


        // navigatorKey.currentState!.pushNamed(RentalRequestDetail.route);

      }


      if (pushNoti.type == "sell") {



        ///Observable.instance.notifyObservers(null);
        Observable.instance.notifyObservers([
          "_SellDetailsRequestState",
        ], notifyName: "custom_data", map: pushNoti.toJson());

        showLoading();
        getSellBookingDetails(
            slug: pushNoti.slug, onSuccess: (data) {
          // RentalBookingDetails
          // rentalBookingDetails = data;
          // widget._rentalBookingDetails = data;
          AdsObj? adsobj;
          adsobj = AdsObj.fromJson({ "id": data.data?.product?.id ,
            "userId": data.data?.product?.userId,
            "categoryId": data.data?.product?.categoryId,
            "name": data.data?.product?.name,
            "slug": data.data?.product?.slug,
            "description": data.data?.product?.description,
            "tags": List<String>.from(data.data!.product!.tags!.map((x) => x)),
            "rentType": data.data?.product?.rentType,
            "rentCharges": data.data?.product?.rentCharges,
            "sellPrice": data.data?.product?.sellPrice,
            "pickUpLocationAddress": data.data?.product?.pickUpLocationAddress,
            "pickupLat": data.data?.product?.pickupLat,
            "pickupLng": data.data?.product?.pickupLng,
            "dropLocationAddress": data.data?.product?.dropLocationAddress,
            "dropLat": data.data?.product?.dropLat,
            "dropLng": data.data?.product?.dropLng,
            "ssn": data.data?.product?.ssn,
            "idCard": data.data?.product?.idCard,
            "drivingLicense": data.data?.product?.drivingLicense,
            "hostingDemos": data.data?.product?.hostingDemos,
            "rating":data.data?.product?.rating,
            "reviews": data.data?.product?.reviews,
            "isSell": data.data?.product?.isSell,
            "isRent": data.data?.product?.isRent,
            "sellStatus": data.data?.product?.sellStatus,
            "pendingRequest": data.data?.product?.pendingRequest,
            "category": data.data!.product!.category!.toJson(),
            "owner":data.data!.product!.category!.toJson(),
            "media": data.data!.product!.media!.map((x) => x.toJson())});

          Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => RentalRequestDetail(
                      "SellRequests",adsobj ,navigatorKey , null, null , data)));
          hideLoading();
        }, onError: (error) {
          hideLoading();
          showToast(error);
        }, jsonData: {});


        // navigatorKey.currentState!.pushNamed(RentalRequestDetail.route);

      }

      if(pushNoti.type == "chat") {

        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Dashboard.route, (route) => false);


        Navigator.of(navigatorKey.currentContext!, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) =>
                ChatScreen(user_name: "${pushNoti.actorName}",
                  chat_Room_id: pushNoti.chatRoomId
                      .toString(), other_id: userObj!.id! == pushNoti.target_id! ? pushNoti.ownerId! : pushNoti.target_id! ,),));

      }


      if(pushNoti.type == "disputes") {
          Navigator.pushNamed(navigatorKey.currentContext!, DisputeDetailsMain.route , arguments: {'slug' : pushNoti.slug , 'type' : pushNoti.product_type});

      }

      if(pushNoti.type == "comments") {
        Navigator.pushNamed(navigatorKey.currentContext!, Reviews.route , arguments: {'reviewsAvg' : "" , 'reviewsCount' : "" , "product_id" : pushNoti.productId });

      }


      if (pushNoti.type == "products") {


        getAdsDetails(slug: pushNoti.slug ?? "", onSuccess: (data) {


          GlobalKey requestsUpdated = GlobalKey();

          Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => RentalRequestDetail("myAds",data,requestsUpdated , null , null , null)) ).then((value) {
            // Navigator.pop(context ,widget.requestsUpdate);
            print("------------Data Come From Back");
            print(value);

          });

        }, onError: (error) {

        });

      }

    }

  }

  String getPrettyJSONString(jsonObject){
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  Future onSelectNotification(String payload) async {
    // Map<dynamic, dynamic> data;
    try {
      print('Notification Selected. Payload: ${payload}');
      if (payload != null) {
        //data = jsonDecode(payload);
        //print("decoded: $data");
        String? action = null;
        String? item_id = null;
        // List custom_data;

        var arr = payload.split(",");
        for (String element in arr) {
          if (element.contains("action")) {
            action = element.substring(9, element.length);
            break;
          }
        }
        // blog, video, document, classreminder, eventreminder;
        for (String element in arr) {
          if (element.contains("item_id")) {
            item_id = element
                .substring(10, element.length)
                .replaceAll("{", "")
                .replaceAll("}", "");
            break;
          }
        }


        print('action->$action');
        print('item_id->$item_id');
        if (action != null && action.isNotEmpty) {
          switch (action) {
            case 'blog':
              print("blog");
              break;
            case 'video':
              print("video");
              break;
            case 'document':
              print("document");
              break;



            default:
              return null;
          }
        }

        /*final quotedString = payload.replaceFirst("status", "").replaceAllMapped(RegExp(r"(\w+)"), (match) {
          return '"${match.group(0)}"';
        });
        data = jsonDecode(quotedString);
        print('Notification Selected. Payload: ${data}');*/
      }
      /*Navigator.of(GlobalVariable.navState.currentContext)
          .push(getPageRoute((context) => BookingDetailPage(bookingId: value['id'])));*/
    } catch (e) {
      print("catch: $e");
    }
    /*await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future<void> showNormalNotification(
      ReceivedNotification? notification , Map<String,dynamic>? message) async {
   print(
      'Show Notification:\n'
          'Title -> ${notification?.title}\n'
          'Body -> ${notification?.body}\n',
    );

    await _flutterLocalNotificationsPlugin.show(
      NotificationType.normal,
      notification?.title,
      notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannel.channelId,
          NotificationChannel.channelName,
          channelDescription: NotificationChannel.channelDesc,
          priority: Priority.high,
          importance: Importance.max,
          icon: '@drawable/ic_notification',
          color: Colors.red,
        ),
      ),
      payload: message.toString(),
    );
  }

  Future<void> _setupFcm() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await fcm.getToken();
    print("Token FCM: $token");


  }




}




class IOSInitializationSettings {
  bool requestSoundPermission;
  bool requestBadgePermission;
  bool requestAlertPermission;

  IOSInitializationSettings({required this.requestSoundPermission , required this.requestBadgePermission , required this.requestAlertPermission});

}

class ReceivedNotification {
  String title;
  String body;

  ReceivedNotification({required this.title ,required this.body});

}

class NotificationChannel {
 static const String channelId = "test";
 static const String channelName = "test";
 static const String channelDesc = "test";
  // NotificationChannel({required this.channelId , required this.channelName , required this.channelDesc});
}

class NotificationType {
  static const int normal = 0;
}