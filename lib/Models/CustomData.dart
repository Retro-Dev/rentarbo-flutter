import 'dart:convert';

CustomData customDataFromJson(String str) => CustomData.fromJson(json.decode(str));

String customDataToJson(CustomData data) => json.encode(data.toJson());

class CustomData {
  CustomData({
    this.uniqueId,
    this.type,
    this.ownerId,
    this.productId,
    this.slug,
    this.targetId,
    this.actorName,
    this.chatRoomId,
    this.dispute_type,
    this.reviewsCount,
    this.reviewsAvg,
  });

  String? uniqueId;
  String? type;
  int? ownerId;
  dynamic productId;
  String? slug;
  int? targetId;
  String? actorName;
  int? chatRoomId;
  String? dispute_type;
  String? reviewsCount;
  String? reviewsAvg;

  factory CustomData.fromJson(Map<String, dynamic> json) => CustomData(
    uniqueId: json["unique_id"],
    type: json["type"],
    ownerId: json["owner_id"],
    productId: json["product_id"],
    slug: json["slug"],
    targetId :  json["target_id"],
    actorName: json["actor_name"],
    chatRoomId: json["chat_room_id"],
    dispute_type: json["product_type"],
    reviewsCount : json["reviewsCount"],
      reviewsAvg : json["reviewsAvg"],
  );

  Map<String, dynamic> toJson() => {
    "unique_id": uniqueId,
    "type": type,
    "owner_id" : ownerId,
    "product_id" : productId,
    "slug" : slug,
    "target_id" : targetId,
    "actor_name" : actorName,
    "chat_room_id" : chatRoomId,
    "product_type" : dispute_type,
    "reviewsCount" : reviewsCount,
    "reviewsAvg" : reviewsAvg,
  };
}
