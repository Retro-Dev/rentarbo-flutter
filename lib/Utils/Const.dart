import 'dart:ui';

import '../Models/User.dart';

class Const {
  static const String USER = 'user';
  static const String FCM_TOKEN = 'fcm_token';
  static const CLIENT_ID = "d8fd1732-582500-44fa-a03c-8d12aacc82de";
  static const MAP_API_KEY = 'AIzaSyCDl6nOon4YgN9tGJuoPdxdExWjsNJFOnE';
  static const IMG_DEFUALT = 'https://rentarbo.dev.retrocubedev.com/images/user-placeholder.jpg';
  static const STRIPESKEY = "sk_test_HhyWo0vnnR1K5399BcB85zRa00xzxE0dvn";
  static const STRIPEPUBLISHKEY = "pk_test_R2lh0jAc5eQFLLe1nNHBPQFH00n0hfasgA";
  // Default preferences
  static const String DEV = 'https://rentarbo.dev.retrocubedev.com/api/';
  static const String QA = 'https://rentarbo.qa.retrocubedev.com/api/';
  static const String CHECK_INTERNET = 'Please check your internet connection!';
  static const String EMPTY = 'is empty.';
  static const String INVALID = 'is invalid.';
  static const String BASE_URL = QA;
  static const String SIGNUP_ENDPOINT = 'user';
  static const String SIGNIN_ENDPOINT = 'user/login';
  static const String OTPVERIFICATION = 'user/verify-code';
  static const String UPDATE_USER_ENDPOINT = 'edit/profile';
  static const String CREATE_FIR = 'add/fir';
  static const String UPLOAD_FILE = 'upload';
  static const String FORGOT_PASSWORD = 'user/forgot-password';
  static const String CHANGE_PASSWORD = 'user/change-password';
  static const String UPDATE_USER = 'user';
  static const String CategoryList = 'category';
  static const String choreList =  'chore';
  static const String Chore_My_Request = 'chore/my-request';
  static const String Chore_My_Schedule = 'chore/my-schedule';
  static const String Chore_My_Complete = 'chore/my-completed';
  static const String Chore_Top_Paid = 'chore/top-paid';
  static const String Chore_Accept_Offer =   'chore/accept-offer';
  static const String Chore_Cancel_Offer = 'chore/cancel-offer';
  static const String Chore_Make_Offer = 'chore/make-offer';
  static const String Chore_Delete = 'chore/';
  static const String Chore_direct_accept = 'chore/request';
  static const String Chore_Request_View = 'chore/offer';
  static const String Chore_cancel_request = 'chore/cancel-accept-req';
  static const String category = 'category';
  static const String createCategory = "user-category";
  static const String createAds = "product";
  static const String deleteAds = "product/";
  static const String removemedia = "remove-media";
  static const String uploadmedia = "upload-media";
  static const String usrBanner = "banner";
  static const String usercategory = "user-category";
  static const String adsDetails = "product/";
  static List<String> categoryTag = ["1"];
  static String type = "map";
  static  String ads = "product";
  static const String resendcode = "user/resend-code";
  static const String createBooking = "booking";
  static const String comment = "comment";
  static const String earn = "payout/earning";
  static const String SOCIAL_SIGNIN_ENDPOINT =  'user/social-login';
  static const String ContactUs = "contact-us";
  static const String disputeList = "dispute?type=";

  // Chore API Endpoints
  static const String CHORE = 'chore';

  static const String LOGOUT = 'user/logout';

  static const String avantaMedium = 'Avanta-Medium';
  static const String aventaRegular = 'Aventa-Regular';

  static const String aventaBold = 'Aventa-Bold';
  static const String aventa = "Aventa";
  static const String MakeCardDefaultOrDelete = 'gateway/card/';
  static const String AddCard = 'gateway/card';
  static const String Bank_payout_external = 'payout/external-account';
  static const String Bank_payout_check_status = 'payout/check-status';
  static const String Bank_payout_persoal_info = 'payout/personal-info';
  static const String GetCardList = 'gateway/card';
  static const String Get_Payment_history =  'payment/history';
  static const String notification = "notification";
  static const String repostProduct = "product/repost";
  static const String returnStatus = "booking";
  static const String Create_Chat = "create-chat";
  static const String Create_Booking_Sell = "sell";
  static const String NotificationSetting = "notification/setting";
  static const String dispute = "dispute";
  static const String notificationBadge = "notification/badge";
}

class ColorsConstant {
  static const squash = const Color(0xfff5af19);
  static const spruce6 = const Color(0x0f0a3746);
  static const vermillion = const Color(0xfff1271a);
  static const slate = const Color(0xff454f63);
  static const tomato = const Color(0xffee2a22);
  static const deepSkyBlue = const Color(0xff167ffb);
  static const grassyGreen = const Color(0xff3fa700);
  static const darkBlueGrey = const Color(0xff243e5a);
  static const grayishColor = const Color.fromRGBO(69, 79, 99, 1.0);
  static const iceBlue = const Color(0xfff0f3f4);
}

class CardBrandConstant{
  static const Visa = 'Visa';
  static const UnionPay = 'UnionPay';
  static const JCB = 'JCB';
  static const Discover = 'Discover';
  static const American_Express = 'American Express';
  static const MasterCard = 'MasterCard';
  static const Diners_Club = 'Diners Club';
}

class SocialLoginConstant{
  static const facebook = 'facebook';
  static const gmail = 'google';
  static const apple = 'apple';

}