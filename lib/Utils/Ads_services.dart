import 'dart:convert';
import 'dart:ffi';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:rentarbo_flutter/Models/ReviewModel.dart';
import '../Models/Ads.dart';
import '../Models/Banner.dart';
import '../Models/Category.dart';
import '../Models/DisputeModule.dart';
import '../Models/Disputes.dart';
import '../Models/NotificationBagde.dart';
import '../Models/UserCategory.dart';

import '../Models/User.dart';

import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/rest_api.dart';


void getAds({
  required String type,
  required String lat,
  required String long,
  required String keyword,
  required String rentType,
  required int category,
  required String distance,
  String? product_id,
  required Function( List<AdsObj>) onSuccess,
  required Function(String error) onError}) {

  var endpoint;


  if (distance == "") {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&rent_type=${rentType}&category=${category}";
  }else {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }

  if (keyword == "") {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }else {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }

  if (lat == "" && long == "") {
    endpoint = "${Const.ads}?type=${type}&keyword=${keyword}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }else {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }

  if (rentType == ""){
    endpoint =  "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&distance=${distance}";
  }else {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }


  if (category == 0) {
    endpoint =  "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&rent_type=${rentType}&distance=${distance}";
  }else {
    endpoint = "${Const.ads}?type=${type}&latitude=${lat}&longitude=${long}&keyword=${keyword}&rent_type=${rentType}&category=${category}&distance=${distance}";
  }

  if (product_id != null) {
    endpoint =  "${Const.ads}?type=${type}&product_id=${product_id ?? ""}";
  }

  invokeAsync(
      method: Method.Get,
      endPoint: endpoint,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => AdsObj.fromJson(x))
            .toList()
            .cast<AdsObj>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}



void getAdsDetails({

  required String slug,
  required Function( AdsObj) onSuccess,
  required Function(String error) onError}) {



  invokeAsync(
      method: Method.Get,
      endPoint: Const.adsDetails + slug,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = AdsObj.fromJson(basemodel.data);


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


// void createAds({required Map<String, dynamic> jsonData,required Function( BaseModel) onSuccess,
//   required Function(String error) onError}) {
//   invokeAsync(
//       method: Method.Post,
//       endPoint: Const.createAds,
//       body: jsonData,
//       onSuccess: (BaseModel basemodel) {
//         // print('basemodel.data ${basemodel.data}');
//         // var list = basemodel.data.map((x) => CategoryObj.fromJson(x))
//         //     .toList()
//         //     .cast<CategoryObj>();
//         //
//
//
//         onSuccess(basemodel);
//       },
//       onError: (String error) {
//         onError(error);
//       });
// }


 Future<void> createAds(
{required Map<String, dynamic> jsonData,
required List<Map<String,dynamic>> files,
required Function(BaseModel basemodel) onSuccess,
required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.createAds,
      body: jsonData,
      files: files,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        onSuccess(baseModel);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> editAds(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required List<Map<String,dynamic>> files,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.deleteAds + slug!,
      body: jsonData,
      files: files,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        onSuccess(baseModel);
      },
      onError: (String error) {
        onError(error);
      });
}


// remove-media

Future<void> removeMedia(
    {
      required Map<String, dynamic> jsonData,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.removemedia,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        onSuccess(baseModel);
      },
      onError: (String error) {
        onError(error);
      });
}

//upload-media
Future<void> uploadMedia(
    {
      required List<Map<String,dynamic>> files,
      required Map<String, dynamic> jsonData,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.uploadmedia,
      body: jsonData,
      files: files,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        onSuccess(baseModel);
      },
      onError: (String error) {
        onError(error);
      });
}



Future<void> deleteAds(
    {
      required String? slug,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Delete,
      endPoint: Const.deleteAds + slug!,
      body: null,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        onSuccess(baseModel);
      },
      onError: (String error) {
        onError(error);
      });
}


void rePostAds({
  required Map<String, dynamic> jsonData,
  required Function( String?) onSuccess,
  required Function(String error) onError}) {



  invokeAsync(
      method: Method.Post,
      endPoint: Const.repostProduct,
      body: jsonData,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');



        onSuccess(basemodel.message);
      },
      onError: (String error) {
        onError(error);
      });
}


void getNotificationBadge({
  required Map<String, dynamic> jsonData,
  required Function( NotificationBadge?) onSuccess,
  required Function(String error) onError}) {



  invokeAsync(
      method: Method.Get,
      endPoint: Const.notificationBadge,
      body: jsonData,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        final notificationBadge = NotificationBadge.fromJson(basemodel.toJson());


        onSuccess(notificationBadge);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> getComments(
    {
      required Map<String, dynamic> jsonData,
      required Function(List<ReviewDatum>) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: Const.comment + "?product_id=" + jsonData['product_id'],
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin

        var list = baseModel.data.map((x) => ReviewDatum.fromJson(x))
            .toList()
            .cast<ReviewDatum>();

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}



// dispute?type=bookings

Future<void> getDispute(
    {
      required Map<String, dynamic> jsonData,
      required Function(List<DisputeDatum>) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: "dispute?type=" + jsonData['type'],
      body: {'type' : jsonData['type']},
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin

        var list = baseModel.data.map((x) => DisputeDatum.fromJson(x))
            .toList()
            .cast<DisputeDatum>();

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> getDisputeDetails(
    {
      required String slug,
      required Map<String, dynamic> jsonData,
      required Function(DisputeData) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: "dispute/${slug}?type=" + jsonData['type'],
      body: {'type' : jsonData['type']},
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin

        var list = DisputeData.fromJson(baseModel.data);


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}
