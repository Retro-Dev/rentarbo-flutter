import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rentarbo_flutter/Controllers/DisputeDetails.dart';
import 'package:rentarbo_flutter/Controllers/DisputeList.dart';
import 'package:rentarbo_flutter/Controllers/Reviews.dart';
import 'package:rentarbo_flutter/main.dart';
import '../Controllers/Chat.dart';
import '../Controllers/DisputeDetailsMain.dart';
import '../Controllers/EditProfile.dart';
import '../Controllers/LinearGraphView.dart';
import '../Controllers/Map.dart';
import '../Controllers/MyAds.dart';
import '../Controllers/MyEarning.dart';
import '../Controllers/MyRentalPost/OtherRequests.dart';
import '../Controllers/Notifications.dart';
import '../Controllers/Payment/Add%20Bank%20Account.dart';
import '../Controllers/Payment/Add%20Credit%20Card.dart';
import '../Controllers/Payment/PaymentDetails.dart';
import '../Controllers/Payment/Payout.dart';
import '../Controllers/PostAdView.dart';
import '../Controllers/RentalRequest/RentalRequestsView.dart';
import '../Controllers/RentalRequests.dart';
import '../Controllers/SearchLocationWithItem.dart';
import '../Controllers/VideoViewScreen.dart';
import '../Controllers/about.dart';
import '../Controllers/account.dart';

import '../Controllers/forgotPassword.dart';
import '../Controllers/inbox.dart';
import '../Controllers/login.dart';
import '../Controllers/onBoardingScreen/onBoardingScreen.dart';
import '../Models/Ads.dart';
import '../Controllers/ChangePassword.dart';
import '../Controllers/DisputeManagement.dart';
import '../Controllers/InboxDetail.dart';
import '../Controllers/MyRendtalPosted.dart';

import '../Controllers/PostAdReview.dart';
import '../Controllers/RentRequestDetail.dart';
import '../Controllers/RentalStatus.dart';
import '../Controllers/Setting.dart';
import '../Controllers/Settings/Contacts.dart';
import '../Controllers/Settings/webview.dart';
import '../Controllers/more.dart';
import '../Controllers/selectCategory.dart';
import '../Controllers/signup.dart';

import '../Controllers/Dashboard.dart';

import '../Controllers/splash.dart';
import '../Controllers/verification.dart';
import '../View/views.dart';
import '../View/custom_dailog_box.dart';
import '../Controllers/Home.dart';
import '../component/SearchLocationPage.dart';



Route<dynamic>? getRoute(RouteSettings settings) {
  late Map<String, Object?> map;
  if (settings.arguments != null) {
    map = settings.arguments as Map<String, Object?>;
  }
  switch (settings.name) {
    case '/':
      return setTransition(Splash());

    case Home.route:
      return setTransition(Home());
    case Login.route:
      return setTransition(Login());

    case ForgotPassword.route:
      return setTransition(ForgotPassword());

    case SignUp.route:
      return setTransition(SignUp());
    case OTPVerification.route:
      return setTransition(OTPVerification());

    case SelectCategory.route:
      return setTransition(SelectCategory(isCommingFromSignUp:  map['isCommingFromSignUp'] as bool,));

    case Dashboard.route:
       return setTransition(const Dashboard());

    case MoreTab.route:
      return setTransition(const MoreTab());

    case AccountTab.route:
      return setTransition(const AccountTab());

    case InboxTab.route:
      return setTransition( InboxTab());
    case PostAd.route:
      return setTransition(const PostAd());

    case EditProfile.route:
      return setTransition(const EditProfile());

    case DisputeManagement.route:
      return setTransition(const DisputeManagement());

    case RentalRequest.route:
      return setTransition(RentalRequest());

    case MyRentalPosted.route:
      return setTransition(const MyRentalPosted());

    case RentalStatus.route:
      return setTransition(const RentalStatus());

    case Payout.route:
      return setTransition(const Payout());

    case Setting.route:
      return setTransition(const Setting());

    case RentalRequestDetail.route:
      print("----------------Route Rental Request Details----------------");
      return setTransition(RentalRequestDetail("Requests", null, navigatorKey, null, null, null));


    case ChangePassword.route:
      return setTransition(const ChangePassword());

    case Notifications.route:
        return setTransition( Notifications());

    case InboxDetail.route:
         return setTransition(const InboxDetail());

    case Chat.route:
          return setTransition(const Chat());

    case SearchLocationWithItem.route:
         return setTransition( SearchLocationWithItem());

    // case MapSearch.route:
    //        return setTransition(const MapSearch());

    case RentalRequestView.route:
           return setTransition(const RentalRequestView());
    case ContactUs.route:
      return setTransition(const ContactUs());

    case About.route:
      return setTransition(
          About(title: map['title'] as String, content: map['content'] as String));



    case OtherRequests.route:
           return setTransition(OtherRequests(isAccept: true, request: true,));

    case AddBankAccount.route:
      return setTransition( AddBankAccount());
    case AddCreditCard.route:
      return setTransition( AddCreditCard());

    case MyEarning.route:
      return setTransition(const MyEarning());

    // case PostAdReview.route:
    //   return setTransition( PostAdReview(images: [], tags: [],));

    case LinearGraphView.route:
      return setTransition( LinearGraphView());

    case OnBoardingScreen.route:
      return setTransition(const OnBoardingScreen());

    case SearchLocationPage.route:
    // 44.500000	‑89.500000
      return  setTransition(SearchLocationPage(userLatLng: map["userLatLng"] as LatLng,));

    case MyAds.route:
      return setTransition(const MyAds());


    case VideoViewScreen.route:
      return setTransition(VideoViewScreen(
        sourceType: map["sourceType"] as VideoSource,
        source: map["source"] as String,
        videoFile: map["videoFile"] as File,
      ));

    case PaymentDetails.route:
      return setTransition(const PaymentDetails());

    case Reviews.route:
      return setTransition(Reviews(product_id: map['product_id'] as int,));

    case DisputeList.route:
      return setTransition(DisputeList());

    case DisputeDetailsMain.route:
      return setTransition(DisputeDetailsMain(slug: map['slug'] as String,type: map['type'] as String,));

    default:
      return null;
  }
}

PageTransition setTransition(Widget widget) {
  var animation =
  Platform.isIOS ? PageTransitionType.rightToLeft : PageTransitionType.fade;
  return PageTransition(
      child: widget, type: animation, duration: Duration(milliseconds: 300));
}

