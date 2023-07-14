// To parse this JSON data, do
//
//     final disputeList = disputeListFromJson(jsonString);

import 'dart:convert';

DisputeList disputeListFromJson(String str) => DisputeList.fromJson(json.decode(str));

String disputeListToJson(DisputeList data) => json.encode(data.toJson());

class DisputeList {
  DisputeList({
    this.disputeData,
  });

  List<DisputeDatum>? disputeData;

  factory DisputeList.fromJson(Map<String, dynamic> json) => DisputeList(
    disputeData: json["DisputeData"] == null ? [] : List<DisputeDatum>.from(json["DisputeData"]!.map((x) => DisputeDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DisputeData": disputeData == null ? [] : List<dynamic>.from(disputeData!.map((x) => x.toJson())),
  };
}

class DisputeDatum {
  DisputeDatum({
    this.id,
    this.moduleId,
    this.module,
    this.userId,
    this.slug,
    this.descripton,
    this.disputeStatus,
    this.declinedDisputeReason,
    this.adminStatus,
    this.createdAt,
    this.images,
    this.user,
  });

  int? id;
  int? moduleId;
  String? module;
  int? userId;
  String? slug;
  dynamic descripton;
  String? disputeStatus;
  dynamic declinedDisputeReason;
  String? adminStatus;
  DateTime? createdAt;
  List<dynamic>? images;
  User? user;

  factory DisputeDatum.fromJson(Map<String, dynamic> json) => DisputeDatum(
    id: json["id"],
    moduleId: json["module_id"],
    module: json["module"],
    userId: json["user_id"],
    slug: json["slug"],
    descripton: json["description"],
    disputeStatus: json["dispute_status"],
    declinedDisputeReason: json["declined_dispute_reason"],
    adminStatus: json["admin_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "module_id": moduleId,
    "module": module,
    "user_id": userId,
    "slug": slug,
    "description": descripton,
    "dispute_status": disputeStatus,
    "declined_dispute_reason": declinedDisputeReason,
    "admin_status": adminStatus,
    "created_at": createdAt?.toIso8601String(),
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "user": user?.toJson(),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.mobileNo,
    this.slug,
    this.imageUrl,
    this.blurImage,
  });

  int? id;
  String? name;
  String? mobileNo;
  String? slug;
  String? imageUrl;
  String? blurImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    mobileNo: json["mobile_no"],
    slug: json["slug"],
    imageUrl: json["image_url"],
    blurImage: json["blur_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_no": mobileNo,
    "slug": slug,
    "image_url": imageUrl,
    "blur_image": blurImage,
  };
}
