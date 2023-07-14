



import 'package:rentarbo_flutter/Models/SellBooking.dart';
import 'package:rentarbo_flutter/Utils/BaseModel.dart';
import 'package:rentarbo_flutter/Utils/rest_api.dart';

import '../Models/SellBookingDetails.dart';
import 'Const.dart';

Future<void> createBookingSell(
    {required Map<String, dynamic> jsonData,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.Create_Booking_Sell,
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


Future<void> getBookingSell(
    {required String? bookingType,
      required String? productId,
      required Map<String, dynamic> jsonData,
      required Function(SellBooking) onSuccess,
      required Function(String error) onError}) async {

  var endpoint = "";
  if (bookingType! == "sent") {
    endpoint =  Const.Create_Booking_Sell + "?type=${bookingType!}";
  }else {
    endpoint =  Const.Create_Booking_Sell + "?type=${bookingType!}&product=${productId}";
  }


  invokeAsync(
      method: Method.Get,
      endPoint: endpoint,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        var list = SellBooking.fromJson(baseModel.toJson());
        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> getSellBookingDetails(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(SellBookingDetails) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: Const.Create_Booking_Sell + "/" + slug!,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin

        SellBookingDetails sellBookingDetails = SellBookingDetails.fromJson(baseModel.toJson());
        onSuccess(sellBookingDetails);
      },
      onError: (String error) {
        onError(error);
      });
}



Future<void> updateSellBookingDetails(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(SellBookingDetails) onSuccess,
      required List<Map<String,dynamic>> files,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.Create_Booking_Sell + "/" + slug!,
      body: jsonData,
      files: files,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        var list = SellBookingDetails.fromJson(baseModel.toJson() );

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}
