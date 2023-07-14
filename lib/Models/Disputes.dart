// To parse this JSON data, do
//
//     final disputeDetails = disputeDetailsFromJson(jsonString);

import 'dart:convert';

DisputeDetails disputeDetailsFromJson(String str) => DisputeDetails.fromJson(json.decode(str));

String disputeDetailsToJson(DisputeDetails data) => json.encode(data.toJson());

class DisputeDetails {
  DisputeDetails({
    this.disputeData,
  });

  DisputeData? disputeData;

  factory DisputeDetails.fromJson(Map<String, dynamic> json) => DisputeDetails(
    disputeData: json["disputeData"] == null ? null : DisputeData.fromJson(json["disputeData"]),
  );

  Map<String, dynamic> toJson() => {
    "disputeData": disputeData?.toJson(),
  };
}

class DisputeData {
  DisputeData({
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
  List<ImageDispute>? images;
  User? user;

  factory DisputeData.fromJson(Map<String, dynamic> json) => DisputeData(
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
    images: json["images"] == null ? [] : List<ImageDispute>.from(json["images"]!.map((x) => ImageDispute.fromJson(x))),
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
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "user": user?.toJson(),
  };
}

class ImageDispute {
  ImageDispute({
    this.id,
    this.thumbnailUrl,
    this.module,
    this.moduleId,
    this.filename,
    this.originalName,
    this.fileUrl,
    this.mimeType,
    this.fileType,
    this.createdAt,
  });

  int? id;
  String? thumbnailUrl;
  String? module;
  int? moduleId;
  String? filename;
  String? originalName;
  String? fileUrl;
  String? mimeType;
  String? fileType;
  DateTime? createdAt;

  factory ImageDispute.fromJson(Map<String, dynamic> json) => ImageDispute(
    id: json["id"],
    thumbnailUrl: json["thumbnail_url"],
    module: json["module"],
    moduleId: json["module_id"],
    filename: json["filename"],
    originalName: json["original_name"],
    fileUrl: json["file_url"],
    mimeType: json["mime_type"],
    fileType: json["file_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail_url": thumbnailUrl,
    "module": module,
    "module_id": moduleId,
    "filename": filename,
    "original_name": originalName,
    "file_url": fileUrl,
    "mime_type": mimeType,
    "file_type": fileType,
    "created_at": createdAt?.toIso8601String(),
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
