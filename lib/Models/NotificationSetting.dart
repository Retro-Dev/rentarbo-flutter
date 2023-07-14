// To parse this JSON data, do
//
//     final notificationSetting = notificationSettingFromJson(jsonString);

import 'dart:convert';

NotificationSetting? notificationSettingFromJson(String str) => NotificationSetting.fromJson(json.decode(str));

String notificationSettingToJson(NotificationSetting? data) => json.encode(data!.toJson());

class NotificationSetting {
  NotificationSetting({
    this.code,
    this.notiSetting,
    this.message,
  });

  int? code;
  NotiSetting? notiSetting;
  String? message;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) => NotificationSetting(
    code: json["code"],
    notiSetting: NotiSetting.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": notiSetting!.toJson(),
    "message": message,
  };
}

class NotiSetting {
  NotiSetting({
    this.all,
  });

  int? all;

  factory NotiSetting.fromJson(Map<String, dynamic> json) => NotiSetting(
    all: json["all"],
  );

  Map<String, dynamic> toJson() => {
    "all": all,
  };
}
