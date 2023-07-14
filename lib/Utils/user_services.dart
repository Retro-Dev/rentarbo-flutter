import 'dart:convert';
import 'dart:ffi';
import 'dart:io';


import 'package:flutter/foundation.dart';
import '../Crypto/Crypto.dart';
import '../Models/Banner.dart';
import '../Models/Category.dart';
import '../Models/Notification.dart';
import '../Models/NotificationSetting.dart';
import '../Models/UserCategory.dart';

import '../Models/User.dart';

import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/rest_api.dart';
import 'package:flutter/material.dart';

/*void getPrivacyPolicy(
    {required Function(BaseModel baseModel) onSuccess,
    required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.PRIVACY_POLICY,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void getTermCondition(
    {required Function(BaseModel baseModel) onSuccess,
    required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.TERMS_CONDITION,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}*/

Future<void> login({required Map<String, dynamic> jsonData,
  required Function(User user) onSuccess,
  required Function(String error) onError}) async {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.SIGNIN_ENDPOINT,
      body: jsonData,
      onSuccess: (BaseModel basemodel) {
        print("----------------Response----------");
        print(basemodel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(basemodel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> signUp({required Map<String, dynamic> jsonData,
  required Function(User user,String message) onSuccess,
  required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.SIGNUP_ENDPOINT,
      body: jsonData,
      onSuccess: (BaseModel baseModel) {

        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(baseModel.data);
        Prefs.setUser(user);
        onSuccess(user,baseModel.message!);
      },
      onError: (String error) {
        onError(error);
      });
}



Future<void> OTPVerificationApi({required Map<String, dynamic> jsonData,
  required Function(User user,String message) onSuccess,
  required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.OTPVERIFICATION,
      body: jsonData,
      onSuccess: (BaseModel baseModel) {

        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(baseModel.data);
        //Prefs.setUser(user);
        onSuccess(user,baseModel.message!);
      },
      onError: (String error) {
        onError(error);
      });
}




Future<void> editProfileWithOutImage({required Map<String, dynamic> jsonData,required String url,
  required Function(User user) onSuccess,
  required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: url,
      body: jsonData,
      onSuccess: (BaseModel baseModel) {

        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(baseModel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}
Future<void> editProfileApi(
    {required Map<String, dynamic> jsonData,required String url,
       String? image,
      required Function(User user) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: url,
      body: jsonData,
      image: image,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(baseModel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}

void uploadFile({required String type,
  required String authToken,
  required List<String> image,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.UPLOAD_FILE,
      //files: image,
      body: {
        "type": type,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void forgotPassword({required String email,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.FORGOT_PASSWORD,
      body: {
        'email': email,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void updateLocationApi({required String address,required double lat,required double lng, required String surfix,
  required Function(User use) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: "${Const.UPDATE_USER}/$surfix",
      body: {
        '_method' : 'PUT',
        'address': address,
        'latitude': lat,
        'longitude': lng,
      },
      onSuccess: (BaseModel basemodel) {
        final user = User.fromJson(basemodel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}


void ChangePasswordAPI({required String old_password,required String new_password,required String confirm_password,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.CHANGE_PASSWORD,
      body: {
        'current_password': old_password,
        'new_password': new_password,
        'confirm_password': confirm_password,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void contactUs({required String name,required String email,required String message,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.ContactUs,
      body: {
        'name': name,
        'email': email,
        'message': message,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}


void logOutUser({required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.LOGOUT,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void updateUser({required String fName,
  required String lName,
  required String mobile_no,
  required String cnic,
  required Function(User user) onSuccess,
  required Function(String error) onError}) {
  /*Future.delayed(Duration(seconds: 2), () {
    Prefs.getUser((user) => onSuccess(user));
  });
  return;*/
  invokeAsync(
      method: Method.Post,
      endPoint: Const.UPDATE_USER_ENDPOINT,
      body: {
        "first_name": fName,
        "last_name": lName,
        "phone": mobile_no,
        "nic": cnic,
      },
      onSuccess: (BaseModel basemodel) {
        // User user = User.fromJson(basemodel.data);
        // Prefs.getUser((savedUser) {
        //   user.data.apiToken = savedUser!.data.apiToken;
        //   Prefs.setUser(user);
        //   onSuccess(user);
        // });
      },
      onError: (String error) {
        onError(error);
      });
}

void forgetPassword({required String email,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.FORGOT_PASSWORD,
      body: {
        'email': email,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void checkStatus({required String cnic,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: "check/status",
      body: {
        'nic': cnic,
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}


// user/resend-code
void reSendVerifyCode({
  required Function(BaseModel basemodel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.resendcode,
      onSuccess: (BaseModel basemodel) {
        // User user = User.fromJson(basemodel.data);
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}


void getProfile({required Function(User user) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: 'api/get_profile',
      onSuccess: (BaseModel basemodel) {
        // User user = User.fromJson(basemodel.data);
        // onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}

void createFIR({required String subject,
  required String desc,
  required String address,
  required String stationId,
  List<String>? images,
  required Function(String message) onSuccess,
  required Function(String error) onError}) {
  // subject:Attempt to murder
  // address:Block 6 defence
  // descriptions:Lorem description for the case Lorem description for the case
  // station_id:1
  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.CREATE_FIR,
      body: {
        "subject": subject,
        "descriptions": desc,
        "address": address,
        "station_id": stationId,
      },
      // files: images,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel.message ?? "");
      },
      onError: (String error) {
        onError(error);
      });
}




void logout({required String authToken,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: 'auth/logout',
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}


void getCategory({required Function( List<CategoryObj>) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.category,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => CategoryObj.fromJson(x))
            .toList()
            .cast<CategoryObj>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


void createCategory({required Map<String, dynamic> jsonData,required Function( BaseModel) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.createCategory,
      body: jsonData,
      onSuccess: (BaseModel basemodel) {
        // print('basemodel.data ${basemodel.data}');
        // var list = basemodel.data.map((x) => CategoryObj.fromJson(x))
        //     .toList()
        //     .cast<CategoryObj>();
        //


        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

void getBanners({required Function(List<Bannerobj>) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.usrBanner,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => Bannerobj.fromJson(x))
            .toList()
            .cast<Bannerobj>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

void getUserCategories({required Function(List<UserCategoryObj>) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.usercategory,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => UserCategoryObj.fromJson(x))
            .toList()
            .cast<UserCategoryObj>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> getUserProfile({required String url,
  required Function(User user) onSuccess,
  required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: url,
      onSuccess: (BaseModel baseModel) {

        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(baseModel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}

void getNotifications({


  required Function( List<Notfi>) onSuccess,
  required Function(String error) onError}) {



  invokeAsync(
      method: Method.Get,
      endPoint: Const.notification,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = List<Notfi>.from(basemodel.data.map((x) => Notfi.fromJson(x)));


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}



Future<void> Sociallogin({required Map<String, dynamic> jsonData,
  required Function(User user) onSuccess,
  required Function(String error) onError}) async {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.SOCIAL_SIGNIN_ENDPOINT,
      body: jsonData,
      onSuccess: (BaseModel basemodel) {
        print("----------------Response----------");
        print(basemodel.data);
        print("----------------Response----------");
        // toString of Response's body is assigned to jsonDataStrin
        final user = User.fromJson(basemodel.data);
        Prefs.setUser(user);
        onSuccess(user);
      },
      onError: (String error) {
        onError(error);
      });
}


void notificationUpdate({required int notification,
  required Function(NotificationSetting?) onSuccess,
  required Function(String error) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.NotificationSetting + "?notification_setting[all]=${notification}",
      body: {
        "notification_setting[all]" : notification,
      },
      onSuccess: (BaseModel basemodel) {
        NotificationSetting? notificationSetting = NotificationSetting.fromJson(basemodel.toJson());
        onSuccess(notificationSetting);
      },
      onError: (String error) {
        onError(error);
      });
}