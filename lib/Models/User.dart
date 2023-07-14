// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../Crypto/Crypto.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.slug,
    this.email,
    this.mobileNo,
    this.imageUrl,
    this.blurImage,
    this.status,
    this.isEmailVerify,
    this.isMobileVerify,
    this.country,
    this.state,
    this.city,
    this.zipcode,
    this.address,
    this.latitude,
    this.longitude,
    this.apiToken,
    this.deviceType,
    this.deviceToken,
    this.platformType,
    this.platformId,
    this.createdAt,
    this.isCardInfo,
    this.isPayoutInfo,
    this.isNotification,
  });

  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? slug;
  String? email;
  String? mobileNo;
  String? imageUrl;
  String? blurImage;
  String? status;
  String? isEmailVerify;
  String? isMobileVerify;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zipcode;
  dynamic address;
  String? latitude;
  String? longitude;
  String? apiToken;
  String? deviceType;
  String? deviceToken;
  String? platformType;
  dynamic platformId;
  DateTime? createdAt;
  int? isCardInfo;
  int? isPayoutInfo;
  int? isNotification;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    slug: json["slug"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    imageUrl: json["image_url"],
    blurImage: json["blur_image"],
    status: json["status"],
    isEmailVerify: json["is_email_verify"],
    isMobileVerify: json["is_mobile_verify"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipcode: json["zipcode"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    apiToken: json["api_token"],
    deviceType: json["device_type"],
    deviceToken: json["device_token"],
    platformType: json["platform_type"],
    platformId: json["platform_id"],
    createdAt: DateTime.parse(json["created_at"]),
    isCardInfo: json["is_card_info"],
    isPayoutInfo: json["is_payout_info"],
    isNotification: json["is_notification"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "slug": slug,
    "email": email,
    "mobile_no": mobileNo,
    "image_url": imageUrl,
    "blur_image": blurImage,
    "status": status,
    "is_email_verify": isEmailVerify,
    "is_mobile_verify": isMobileVerify,
    "country": country,
    "state": state,
    "city": city,
    "zipcode": zipcode,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "api_token": CryptoAES.encryptAESCryptoJS(apiToken ?? "")  == null ? null : CryptoAES.encryptAESCryptoJS(apiToken ?? ""),
    "device_type": deviceType,
    "device_token": deviceToken,
    "platform_type": platformType,
    "platform_id": platformId,
    "created_at": createdAt?.toIso8601String(),
    "is_card_info": isCardInfo,
    "is_payout_info": isPayoutInfo,
    "is_notification": isNotification,
  };
}
