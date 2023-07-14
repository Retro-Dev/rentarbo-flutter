import 'dart:convert';
import 'dart:io';


import 'package:mime/mime.dart';

import '../Utils/utils.dart';
import '../main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../Controllers/login.dart';
import '../Crypto/Crypto.dart';
import '../Models/User.dart';
import 'BaseModel.dart';
import 'Const.dart';
import 'Prefs.dart';


String baseUrl = Const.BASE_URL;

Future<BaseModel> POST_JSON(String endPoint, jsonBody,
    {String? authToken}) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "token": CryptoAES.encryptAESCryptoJS(Const.CLIENT_ID),
    "Authorization": authToken == null ? "Bearer" : 'Bearer $authToken',
    "user-token": authToken == null ? "" : authToken,
  };
  // make POST request
  String url = baseUrl + endPoint;
  http.Response response = await http.post(Uri.parse(url),
      headers: headers, body: jsonBody != null ? jsonEncode(jsonBody) : null);

  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  if (statusCode == 200) {
    String body = response.body;
    body = utf8.decode(body.runes.toList());
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else if (statusCode == 400) {
    String body = response.body;
    Map<String, dynamic> jsonBody = json.decode(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

Future<BaseModel> DELETE(String endPoint,
    {String? authToken, required String id}) async {
  Map<String, String> headers = {
    "token": CryptoAES.encryptAESCryptoJS(Const.CLIENT_ID),
    "Authorization": authToken == null ? "Bearer" : 'Bearer $authToken',
    "user-token": authToken == null ? "" : authToken,
  };
  String bUrl = baseUrl + endPoint;
  final url = Uri.encodeFull(bUrl + id);
  http.Response response = await http.delete(
    Uri.parse(url),
    headers: headers,
  );
  print("----------------URI--------------------------");
  print(url);
  print("----------------URI---------------------------");
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  if (statusCode == 200) {
    String body = response.body;
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

Future<BaseModel> POST_FORM_DATA(String endPoint, Map<String, dynamic> body,
    {String? authToken}) async {
//  String url = 'https://360cubes.com/urantia_staging/public/api/user/login';

  Map<String, String> headers = {
//    "Content-Type": "application/x-www-form-urlencoded",
//    "token": "api.Pd*!(5675",
    "token": CryptoAES.encryptAESCryptoJS(Const.CLIENT_ID),
    "Authorization": authToken == null
        ? "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUsImlhdCI6MTU3MDc3NDE0NX0.KpeFmLLKXmqmDFhP4Jr_6i-fbhQFLwiIPuSlB6Izfvw"
        : 'Bearer $authToken',
  };
//  Map<String, String> body = {
//    'email': 'android@reader.com',
//    'password': '123456',
//  };
  // make POST request
  http.Response response = await http.post(Uri.parse(baseUrl + endPoint),
      headers: headers, body: body);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  if (statusCode == 200) {
    String body = response.body;
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

Future<BaseModel> GET(String endPoint,
    {String? authToken, Map<String, dynamic>? params}) async {
//  String url = 'https://360cubes.com/urantia_staging/public/api/user/login';

  Map<String, String> headers = {
    // "Content-Type": "application/json",
//    "token": "api.Pd*!(5675",
    "token": CryptoAES.encryptAESCryptoJS(Const.CLIENT_ID),

    "Authorization": authToken == null
        ? "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjUsImlhdCI6MTU3MDc3NDE0NX0.KpeFmLLKXmqmDFhP4Jr_6i-fbhQFLwiIPuSlB6Izfvw"
        : 'Bearer $authToken',
    "user-token": authToken!,
  };

  print('headers $headers');

  String url = baseUrl + endPoint;
  Uri parsedUri = Uri.parse(url);
  var uri = parsedUri.replace(queryParameters: params);
  http.Response response = await http.get(
    params != null ? uri : parsedUri,
    headers: headers,
  );
  print("-----------------------------URI-----------------------");
  print(uri);
  print("------------------------------URI----------------------");
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  if (statusCode == 200) {
    String body = response.body;
    body = utf8.decode(body.runes.toList());
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

Future<BaseModel> MultiPart(String endPoint, Map<String, dynamic> body,
    List<Map<String, dynamic>>? files, String? image,
    {String? authToken}) async {
  var uri = Uri.parse(baseUrl + endPoint);

  var request = http.MultipartRequest('POST', uri)
    ..headers.addAll({
      "Content-Type": "application/json",
      "token": CryptoAES.encryptAESCryptoJS(Const.CLIENT_ID),
      "Authorization": authToken == null ? "Bearer" : 'Bearer $authToken',
      "user-token": authToken == null ? "" : authToken,
    });

  body.forEach((key, val) {

      request.fields[key] = val.toString();
    });

  if (files != null && files.isNotEmpty) {
    for (int i = 0; i < files.length; i++) {

      var file = files[i];
      var path = file["path"] as String;
      print(lookupMimeType(path));
      var type = lookupMimeType(path) as String;
      var types =  type.split("/");
      print("file ${file}");

      request.files.add(await http.MultipartFile.fromPath(
        file["name"],
        file["path"],
        contentType: MediaType(types[0] , types[1]) ,
      ));
    }
  }

  // File check = File(image!);
  // print("check krwa oye $check");

  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'image_url',
      image,
      contentType: MediaType('image', 'jpeg'),
    ));
  }

  var response = await request.send();
  int statusCode = response.statusCode;

  if (statusCode == 200) {
    String bodyString = await response.stream.bytesToString();
    // body = utf8.decode(body.runes.toList());
    var jsonBody = json.decode(bodyString);
    print(bodyString);
    return BaseModel.fromJson(jsonBody);
  } else if (statusCode == 400) {
    String bodyString = await response.stream.bytesToString();
    // var jsonBody = json.decode(bodyString);
    Map<String, dynamic> jsonBody = json.decode(bodyString);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

enum Method { Get, Post, Multipart, Delete }

Future<BaseModel> invoke(
    {required String endPoint,
      required Method method,
      Map<String, dynamic>? body,
      String? authToken}) async {
//  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  if (await isConnected()) {
    print(baseUrl + endPoint);
    BaseModel baseModel = (method == Method.Get)
        ? await GET(endPoint, authToken: authToken)
        : await POST_FORM_DATA(endPoint, body!, authToken: authToken);
    if (baseModel.code == 200)
      return baseModel;
    else
      throw baseModel.message ?? "";
  } else {
    throw Const.CHECK_INTERNET;
  }
}

Future<void> invokeAsync(
    {required String endPoint,
      required Method method,
      Map<String, dynamic>? body,
      String? image,
      List<Map<String, dynamic>>? files,
      required Function(BaseModel baseModel) onSuccess,
      required Function(String error) onError}) async {
  if (await isConnected()) {
    print("API EndPoint: $endPoint \nMethod: ${describeEnum(method)}");
    try {
      User? user = (await Prefs.getUserSync());
      print("---------------Api Token--encrypted-----------");
      print(user?.apiToken);
      print("---------------Api Token----encrypted---------");
      String? authToken =
      user != null && user.apiToken != null && user.apiToken!.isNotEmpty
          ? user.apiToken
          : null;
      BaseModel baseModel;
//      = (method == Method.Get)
//          ? await GET(endPoint,authToken: authToken)
//          : await POST_FORM_DATA(endPoint, body, authToken: authToken);

      if (body != null) print("Request Body: " + body.toString());
      // if (files != null && files.isNotEmpty)
      // for (var file in files) {
      //   print("Request Body File: " + file);
      // }
      switch (method) {
        case Method.Get:
          baseModel = await GET(endPoint, authToken: authToken, params: body);
          break;

        case Method.Post:
          print('Post api');
          baseModel = await POST_JSON(
            endPoint,
            body,
            authToken: authToken,
          );
          break;

        case Method.Delete:
          baseModel =
          await DELETE(endPoint, authToken: authToken, id: "");
          break;

        case Method.Multipart:
        default:
          baseModel = await MultiPart(
            endPoint,
            body!,
            files,
            image,
            authToken: authToken,
          );
      }

      print("base model = $baseModel");
      if (baseModel.code == 200) {
        onSuccess(baseModel);
      } else if (baseModel.code == 400) {
        onError((baseModel.data as Map).values.toList()[0]);
      } else {
        onError(baseModel.message ?? "");
        if (baseModel.message == "User is blocked or deleted by admin") {
          // toast("Logging Out");
          Prefs.removeUser();
          navigatorKey.currentState?.pushReplacementNamed(Login.route);
        }
      }
    } catch (error) {
      print(error.toString());
      onError(error.toString());
    }
  } else {
    onError(Const.CHECK_INTERNET);
  }
}

