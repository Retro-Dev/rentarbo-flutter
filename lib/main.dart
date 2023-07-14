import 'dart:async';

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rentarbo_flutter/Controllers/RentRequestDetail.dart';
import 'package:rentarbo_flutter/Models/Ads.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'Controllers/ChatScreen.dart';
import 'Controllers/Dashboard.dart';
import 'Controllers/DisputeDetailsMain.dart';
import 'Controllers/Reviews.dart';
import 'Models/CustomData.dart';
import 'Models/RentalBooking.Dart.dart';
import 'Models/User.dart';
import 'Utils/Ads_services.dart';
import 'Utils/BaseModel.dart';
import 'Utils/BookingAds.dart';
import 'Utils/Const.dart';
import 'Utils/Prefs.dart';
import 'Utils/Sell_Services.dart';
import 'firebase_options.dart';
import 'NotificationConfig.dart';

import 'Route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';



import 'View/views.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

RouteSettings? setting;


AndroidNotificationChannel channel = const AndroidNotificationChannel(
'high_importance_channel', // id
'High Importance Notifications', //
importance: Importance.high,
);
bool isFlutterLocalNotificationsInitialized = false;


// final navigatorKey = GlobalKey<NavigatorState>();
late final FirebaseMessaging _messaging;

User? userObj;

load() async {
  Prefs.getUser((User? user) {

      userObj = user;
  });
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _messaging = FirebaseMessaging.instance;
  await NotificationConfig.init();
  load();
  getToken();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    // await FirebaseMessaging.onMessageOpenedApp.toSet();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.getNotificationSettings();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await setupFlutterNotifications();
  // await NotificationConfig.init();
  Stripe.publishableKey = Const.STRIPEPUBLISHKEY;
  Stripe.merchantIdentifier = Const.STRIPESKEY;
  await Stripe.instance.applySettings();

  // IOSInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true);



   // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
     if (kDebugMode) {
       print('getInitialMessage data: ${message?.data}');
     }


   });

   // onMessage: When the app is open and it receives a push notification
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {



     if (kDebugMode) {
       print("onMessage data: ${message.data}");
     }
     final customData = customDataFromJson(message.data["custom_data"]);

     if (customData.type == "booking") {

       Map map = {};
       map["type"] = customData.type;
       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_RentalRequestState",
       ], notifyName : "data",map: customData.toJson());

       Map mapother = {};
       mapother["type"] = customData.type;
       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_OtherRequestsState",
       ], notifyName : "data",map: customData.toJson());

       Map mapother1 = {};
       mapother["type"] = customData.type;
       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_RentalRequestContentViewState",
       ], notifyName : "data",map: customData.toJson());


       Map mapother2 = {};
       mapother["type"] = customData.type;
       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_RentalRequestDetailState",
       ], notifyName : "data",map: customData.toJson());




       // _SellDetailsRequestState

     }

     if (customData.type == "sell") {
       Map mapotherSell1 = {};
       mapotherSell1["type"] = customData.type;
       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_SellDetailsRequestState",
       ], notifyName : "data",map: mapotherSell1);
     }

     if (customData.type == "disputes") {

     }





   });

   // replacement for onResume: When the app is in the background and opened directly from the push notification.
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

     print("---------Clicked Notifcation--------");

     if (kDebugMode) {
       print('onMessageOpenedApp data: ${message.data}');
     }
     final customData = customDataFromJson(message.data["custom_data"]);

     if (kDebugMode) {
       print("-----------Custom Data-------------");
     }
     print(customData.toJson());

     if (kDebugMode) {
       print("-----------Custom Data-------------");
     }

     if (customData.type == "booking") {

       Observable.instance.notifyObservers([
         "_RentalRequestContentViewState",
       ], notifyName : "custom_data",map: customData.toJson());

       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_RentalRequestDetailState",
       ], notifyName: "custom_data", map: customData.toJson());

       showLoading();
       getRentalBookingDetails(
           slug: customData.slug, onSuccess: (data) {
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


     if (customData.type == "sell") {



       ///Observable.instance.notifyObservers(null);
       Observable.instance.notifyObservers([
         "_SellDetailsRequestState",
       ], notifyName: "custom_data", map: customData.toJson());

       showLoading();
       getSellBookingDetails(
           slug: customData.slug, onSuccess: (data) {
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


     if (customData.type == "products") {


         getAdsDetails(slug: customData.slug ?? "", onSuccess: (data) {


             GlobalKey requestsUpdated = GlobalKey();

             Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => RentalRequestDetail("myAds",data,requestsUpdated , null , null , null)) ).then((value) {
               // Navigator.pop(context ,widget.requestsUpdate);
               print("------------Data Come From Back");
               print(value);

             });

         }, onError: (error) {

         });

     }


     if(customData.type == "chat") {

       // Navigator.pushNamedAndRemoveUntil(
       //     navigatorKey.currentContext!, Dashboard.route, (route) => false);

       Navigator.of(navigatorKey.currentContext!, rootNavigator: true).push(
           MaterialPageRoute(builder: (context) =>
               ChatScreen(user_name: "${customData.actorName}",
                 chat_Room_id: customData.chatRoomId
                     .toString(), other_id: userObj!.id! == customData.targetId! ? customData.ownerId! : customData.targetId! ,),));
     }


     if (customData.type == "disputes") {
       Navigator.pushNamed(navigatorKey.currentContext!, DisputeDetailsMain.route , arguments: {'slug' : customData.slug , 'type' : customData.dispute_type});
     }

     if(customData.type == "comments") {
       Navigator.pushNamed(navigatorKey.currentContext!, Reviews.route , arguments: {'reviewsAvg' : "" , 'reviewsCount' : "" , "product_id" : customData.productId });

     }


     // _SellDetailsRequestState

   });


  runApp(const MyApp());

}



// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//   final String? payload = notificationResponse.payload;
//   if (notificationResponse.payload != null) {
//     debugPrint('notification payload: $payload');
//   }
//
// }
//
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
//   final String? payload = notificationResponse.payload;
//   if (notificationResponse.payload != null) {
//     debugPrint('background notification payload: $payload');
//   }

// }



void registerNotification() async {
  // 1. Initialize the Firebase app
  // await Firebase.initializeApp();


  // Add the following line
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.getNotificationSettings();
  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    if (kDebugMode) {
      print('User granted permission');
    }
    getToken();
    //sshowNotification();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print("FirebaseMessaging.onMessage.");
      }
      if (kDebugMode) {
        print(notification.toString());
      }
      if (kDebugMode) {
        print('${message.data}');
      }

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(
        //         channel.id,
        //         channel.name,
        //         icon: android?.smallIcon,
        //         // other properties...
        //       ),
        //     ));

        if (kDebugMode) {
          print("AndroidNotificationDetails");
        }
        const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
        const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        flutterLocalNotificationsPlugin.show(
            0, 'plain title', 'plain body', notificationDetails,
            payload: message.data.toString());
      }
    });
  } else {
    if (kDebugMode) {
      print('User declined or has not accepted permission');
    }
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{


    Prefs.getUser((User? user) {

      if(user != null)
      {
        // navigatorKey.currentState!.pushNamed(NotificationsScreen.route);
      }
    });


    // Navigator.push(
    //   context,
    //   new MaterialPageRoute(builder: (context) =>  NotificationsScreen()),
    // );

  });

}


void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null ) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@drawable/ic_notification',
          color: Colors.red,
        ),
      ),
    );
  }
}

void getToken() async
{
  await _messaging.getToken().then((deviceToken) {
    if (kDebugMode) {
      print('deviceToken $deviceToken');
    }

    Prefs.setFCMToken(deviceToken!);

  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

var navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {


    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    if (kDebugMode) {
      print('State: MyApp');
    }


    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        statusBarBrightness:  Brightness.dark,
        statusBarIconBrightness: Brightness.dark),
    );

    // Color? hintColor = Colors.grey[500];

    return OKToast(
      child: WillPopScope(
        onWillPop: onWillPop,
        child:ScreenUtilInit(builder:  (context, child) =>  MaterialApp(
          title: 'Rentarbo',
          color: Colors.black,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: getRoute,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              systemOverlayStyle: Platform.isIOS
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              backgroundColor: const Color(0x00000000),
              elevation: 0,
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Aventa',
          ),

          builder: (context, widget) {
            return  FlutterEasyLoading(child: widget!);
          },

        ),),




      ),
    );
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      toast('Press again to exit!');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
