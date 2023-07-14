// To parse this JSON data, do
//
//     final pushNoti = pushNotiFromJson(jsonString);

import 'dart:convert';

PushNoti? pushNotiFromJson(String str) => PushNoti.fromJson(json.decode(str));

String pushNotiToJson(PushNoti? data) => json.encode(data!.toJson());

class PushNoti {
  PushNoti({
    this.userBadge,
    this.priority,
    this.message,
    this.customData,
  });

  int? userBadge;
  String? priority;
  Message? message;
  CustomData? customData;

  factory PushNoti.fromJson(Map<String, dynamic> json) => PushNoti(
    userBadge: json["user_badge"],
    priority: json["priority"],
    message: Message.fromJson(json["message"]),
    customData: CustomData.fromJson(json["custom_data"]),
  );

  Map<String, dynamic> toJson() => {
    "user_badge": userBadge,
    "priority": priority,
    "message": message!.toJson(),
    "custom_data": customData!.toJson(),
  };
}

class CustomData {
  CustomData({
    this.uniqueId,
    this.ownerId,
    this.productId,
    this.type,
    this.slug,
    this.target_id,
    this.actorName,
    this.chatRoomId,
    this.product_type,
  });

  String? uniqueId;
  int? ownerId;
  dynamic productId;
  int? target_id;
  String? type;
  String? slug;
  String? actorName;
  int? chatRoomId;
  String? product_type;

  factory CustomData.fromJson(Map<String, dynamic> json) => CustomData(
    uniqueId: json["unique_id"],
    ownerId: json["owner_id"],
    productId: json["product_id"],
    type: json["type"],
    slug: json["slug"],
    target_id: json["target_id"],
    actorName: json["actor_name"],
    chatRoomId: json["chat_room_id"],
      product_type : json["product_type"],
  );

  Map<String, dynamic> toJson() => {
    "unique_id": uniqueId,
    "owner_id": ownerId,
    "product_id": productId,
    "type": type,
    "slug": slug,
    "target_id" : target_id,
    "chat_room_id" : chatRoomId,
    "product_type" : product_type,
  };
}

class Message {
  Message({
    this.sound,
    this.title,
    this.body,
  });

  String? sound;
  String? title;
  String? body;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    sound: json["sound"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "sound": sound,
    "title": title,
    "body": body,
  };
}
