

import '../Models/BankInfo.dart';
import '../Models/CardDetailModel.dart';
import '../Models/PayoutPersonalInfoModel.dart';
import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/rest_api.dart';



class BankAndCardServices
{
  static Future<void> AddPersonalInfo(
      { required String url,
        required Map<String,dynamic> params,
        required List<Map<String,dynamic>> files,
        required Function(PayoutPersonalInfoModel chore) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Multipart,
        endPoint: '${url}',
        body: params,
        //image: image,
        files: files,
        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataStrin
          onSuccess(PayoutPersonalInfoModel.fromJson(baseModel.data));
        },
        onError: (String error) {
          onError(error);
        });
  }

  static Future<void> AddPersonalInfowithOutImage(
      { required String url,
        required Map<String,dynamic> params,
        required Function(PayoutPersonalInfoModel personalInfo) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Post,
        endPoint: '${url}',
        body: params,
        //image: image,
        // files: files,
        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataStrin
          onSuccess(PayoutPersonalInfoModel.fromJson(baseModel.data));
        },
        onError: (String error) {
          onError(error);
        });
  }

  static Future<void> AddBankInfo(
      { required String url,
        required Map<String,dynamic> params,
        required Function(BankInfo bankInfo) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Post,
        endPoint: '${url}',
        body: params,
        //image: image,
        // files: files,
        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataStrin
          onSuccess(BankInfo.fromJson(baseModel.data));
        },
        onError: (String error) {
          onError(error);
        });
  }


  static Future<void> getPayoutPersonalInfo(
      {
        required String apiUrl,
        required Function(PayoutPersonalInfoModel chore) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Get,
        endPoint: apiUrl,
        //  body: chore.toJson(),
        // image: image,
        //files: images,
        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataStrin
          onSuccess(PayoutPersonalInfoModel.fromJson(baseModel.data));
        },
        onError: (String error) {
          onError(error);
        });
  }

  static Future<void> getCardList(
      {
        required String apiUrl,
        required Function(List<CardDetailsModel> cardDetail) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Get,
        endPoint: apiUrl,

        onSuccess: (BaseModel baseModel) {
          print('basemodel.data ${baseModel.data}');
          var list = baseModel.data.map((x) => CardDetailsModel.fromJson(x))
              .toList()
              .cast<CardDetailsModel>();
          //


          onSuccess(list);
        },
        onError: (String error) {
          onError(error);
        });
  }


  static Future<void> getPayoutStatus(
      {
        required String apiUrl,
        required Function(CheckAccountStatusModel? personalData) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Get,
        endPoint: apiUrl,

        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataString
          CheckAccountStatusModel value = CheckAccountStatusModel.fromJson(baseModel.data);
          onSuccess(value);
        },
        onError: (String error) {
          onError(error);
        });
  }


  static Future<void> deleteCardApiMehtod({required Map<String, dynamic> params,required Function(int code,String message) onSuccess,
    required Function(String error) onError}) async {
    invokeAsync(
        method: Method.Delete,
        endPoint: Const.MakeCardDefaultOrDelete + params["id"],
        body: params,
        onSuccess: (BaseModel basemodel) {

          print(' basemodel.code $basemodel.code');

          onSuccess(basemodel.code ?? 0,basemodel.message!);
        },
        onError: (String error) {
          onError(error);
        });

  }

  static Future<void> markAsDefaultCard(
      { required String url,
        required Map<String,dynamic> params,
        required Function(int code,String message) onSuccess,
        required Function(String error) onError}) async {

    invokeAsync(
        method: Method.Post,
        endPoint: '${url}',
        body: params,
        //image: image,
        // files: files,
        onSuccess: (BaseModel baseModel) {
          print("----------------Response----------");
          print(baseModel.data);
          print("----------------Response----------");
          // toString of Response's body is assigned to jsonDataStrin
          // print(' basemodel.code $basemodel.code');

          onSuccess(baseModel.code ?? 0,baseModel.message!);
        },
        onError: (String error) {
          onError(error);
        });
  }
}