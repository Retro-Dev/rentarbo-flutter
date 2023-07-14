
import 'package:rentarbo_flutter/Models/Earning.dart';
import 'package:rentarbo_flutter/Models/ReturnStatus.dart';

import '../Models/BookingAdsRental.dart';
import '../Models/PaymentHistoryModel.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalBookingDetails.dart';
import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/rest_api.dart';



Future<void> createBookingAds(
    {required Map<String, dynamic> jsonData,
      required List<Map<String,dynamic>> files,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.createBooking,
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

void getRentalBookingAds({
  String? bookingType,
  String? productId,
  required Function( List<RentalBookingdatum>) onSuccess,
  required Function(String error) onError}) {

  var endpoint = "";
   if (bookingType! == "sent") {
     endpoint =  Const.createBooking + "?booking_type=${bookingType!}";
   }else {
   endpoint =  Const.createBooking + "?booking_type=${bookingType!}" + "&product=${productId ?? 0}";
   }

  invokeAsync(
      method: Method.Get,
      endPoint: endpoint,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => RentalBookingdatum.fromJson(x))
            .toList()
            .cast<RentalBookingdatum>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> getRentalBookingDetails(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(RentalBookingDetails) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: Const.createBooking + "/" + slug!,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        var list = RentalBookingDetails.fromJson(baseModel.toJson() );

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> getRentalBookingDetailsNoti(
    {required Map<String, dynamic> jsonData,
      required String product_id,
      required String booking_type,
      required Function(List<RentalBookingdatum>) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: "${Const.createBooking}",
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------getRentalBookingDetailsNoti Response----------");
        print(baseModel.data);
        print("----------------getRentalBookingDetailsNoti Response----------");

        var mainlist = baseModel.data as List;
        List<RentalBookingdatum> list = [];

        var listval = RentalBookingdatum.fromJson(mainlist.first);
         list.add(listval);
        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> updateBookingDetails(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(RentalBookingDetails) onSuccess,
      required List<Map<String,dynamic>> files,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: Const.createBooking + "/" + slug!,
      body: jsonData,
      files: files,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        var list = RentalBookingDetails.fromJson(baseModel.toJson() );

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

// comment

Future<void> addCommentForBooking(
    {required Map<String, dynamic> jsonData,
      required Function(BaseModel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Post,
      endPoint: Const.comment,
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


Future<void> getPaymentHistoryithPagination({required String url,required Map<String, dynamic> params,required Function(List<PaymentHistoryModel> list,Pagination? pagination) onSuccess,
  required Function(String error) onError}) async {
  invokeAsync(
      method: Method.Get,
      endPoint: url,
      body: params,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => PaymentHistoryModel.fromJson(x))
            .toList()
            .cast<PaymentHistoryModel>();
        //


        onSuccess(list,basemodel.pagination);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> getPaymentHistory({required Map<String, dynamic> params,required Function(List<PaymentHistoryModel> list) onSuccess,
  required Function(String error) onError}) async {
  invokeAsync(
      method: Method.Get,
      endPoint: Const.Get_Payment_history,
      body: params,
      onSuccess: (BaseModel basemodel) {
        print('basemodel.data ${basemodel.data}');
        var list = basemodel.data.map((x) => PaymentHistoryModel.fromJson(x))
            .toList()
            .cast<PaymentHistoryModel>();
        //


        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> getEarning(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(Earning) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: Const.earn,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
       var list = Earning.fromJson(baseModel.data);

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> getReturnStatus(
    {required Map<String, dynamic> jsonData,
      required String? slug,
      required Function(ReturnStatus) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Get,
      endPoint: Const.returnStatus,
      body: jsonData,
//files: images,
      onSuccess: (BaseModel baseModel) {
        print("----------------Response----------");
        print(baseModel.data);
        print("----------------Response----------");
// toString of Response's body is assigned to jsonDataStrin
        var list = ReturnStatus.fromJson(baseModel.toJson());

        onSuccess(list);
      },
      onError: (String error) {
        onError(error);
      });
}


Future<void> create_chat(
    {required String user_id,
      required String other_id,
      required Function(BaseModel basemodel) onSuccess,
      required Function(String error) onError}) async {
  invokeAsync(
      method: Method.Post,
      endPoint: Const.Create_Chat,
      body:{
        "user_id": user_id,
        "other_id" : other_id
      },
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error) {
        onError(error);
      });
}

Future<void> openDisputeApi(
    {required String? module,
      required String? module_id,
      required String? description,
      required List<Map<String,dynamic>> files,
      required Function(BaseModel) onSuccess,
      required Function(String error) onError}) async {

  invokeAsync(
      method: Method.Multipart,
      endPoint: "${Const.dispute}?module=${module}&module_id=${module_id}&description=${description}",
      body: {"module" : module , "module_id" : module_id , "description" : description},
      files: files,
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

