// To parse this JSON data, do
//
//     final rentalBookingDetails = rentalBookingDetailsFromJson(jsonString);

import 'dart:convert';

import 'RentalBooking.Dart.dart';

RentalBookingDetails rentalBookingDetailsFromJson(String str) => RentalBookingDetails.fromJson(json.decode(str));

String rentalBookingDetailsToJson(RentalBookingDetails data) => json.encode(data.toJson());

class RentalBookingDetails {
  RentalBookingDetails({
    this.data,
  });

  Data? data;

  factory RentalBookingDetails.fromJson(Map<String, dynamic> json) => RentalBookingDetails(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.productOwnerId,
    this.slug,
    this.productId,
    this.rentarName,
    this.phoneNo,
    this.details,
    this.duration,
    this.totalCharges,
    this.adminTax,
    this.netAmount,
    this.demoHosting,
    this.bookingStatus,
    this.is_repost,
    this.returnedAt,
    this.returned,
    this.returnConfirmed,
    this.createdAt,
    this.rentar,
    this.owner,
    this.product,
    this.license,
    this.rating,

  });

  int? id;
  int? userId;
  int? productOwnerId;
  String? slug;
  int? productId;
  String? rentarName;
  String? phoneNo;
  String? details;
  int? duration;
  String? totalCharges;
  String? adminTax;
  String? netAmount;
  String? demoHosting;
  String? bookingStatus;
  String? is_repost;
  dynamic returnedAt;
  String? returned;
  dynamic returnConfirmed;
  DateTime? createdAt;
  Owner? rentar;
  Owner? owner;
  Product? product;
  List<License>? license;
  Rating? rating;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    productOwnerId: json["product_owner_id"],
    slug: json["slug"],
    productId: json["product_id"],
    rentarName: json["rentar_name"],
    phoneNo: json["phone_no"],
    details: json["details"],
    duration: json["duration"],
    totalCharges: json["total_charges"],
    adminTax: json["admin_tax"],
    netAmount: json["net_amount"],
    demoHosting: json["demo_hosting"],
    bookingStatus: json["booking_status"],
    is_repost : json["is_repost"],
    returnedAt: json["returned_at"],
    returned: json["returned"],
    returnConfirmed: json["return_confirmed"],
    createdAt: DateTime.parse(json["created_at"]),
    rentar: Owner.fromJson(json["rentar"]),
    owner: Owner.fromJson(json["owner"]),
    product: Product.fromJson(json["product"]),
    license: List<License>.from(json["license"].map((x) => License.fromJson(x))),
    rating: json["rating"] != null ? Rating.fromJson(json["rating"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_owner_id": productOwnerId,
    "slug": slug,
    "product_id": productId,
    "rentar_name": rentarName,
    "phone_no": phoneNo,
    "details": details,
    "duration": duration,
    "total_charges": totalCharges,
    "admin_tax": adminTax,
    "net_amount": netAmount,
    "demo_hosting": demoHosting,
    "booking_status": bookingStatus,
    "returned_at": returnedAt,
    "returned": returned,
    "return_confirmed": returnConfirmed,
    "created_at": createdAt!.toIso8601String(),
    "rentar": rentar!.toJson(),
    "owner": owner!.toJson(),
    "product": product!.toJson(),
    "license": List<dynamic>.from(license!.map((x) => x.toJson())),
    "rating": rating?.toJson(),
  };
}

class License {
  License({
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

  factory License.fromJson(Map<String, dynamic> json) => License(
    id: json["id"],
    thumbnailUrl: json["thumbnail_url"],
    module: json["module"],
    moduleId: json["module_id"],
    filename: json["filename"],
    originalName: json["original_name"],
    fileUrl: json["file_url"],
    mimeType: json["mime_type"],
    fileType: json["file_type"],
    createdAt: DateTime.parse(json["created_at"]),
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
    "created_at": createdAt!.toIso8601String(),
  };
}

class Owner {
  Owner({
    this.id,
    this.name,
    this.slug,
    this.imageUrl,
    this.blurImage,
    this.description,
    this.mobileNo,

  });

  int? id;
  String? name;
  String? slug;
  String? imageUrl;
  String? blurImage;
  String? description;
  String? mobileNo;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    imageUrl: json["image_url"],
    mobileNo: json["mobile_no"],
    blurImage: json["blur_image"] == null ? null : json["blur_image"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "image_url": imageUrl,
    "blur_image": blurImage == null ? null : blurImage,
    "description": description == null ? null : description,
  };
}

class Rating {
  Rating({
    this.id,
    this.userId,
    this.bookingId,
    this.productId,
    this.slug,
    this.comment,
    this.rating,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? bookingId;
  int? productId;
  String? slug;
  String? comment;
  dynamic rating;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json["id"],
    userId: json["user_id"],
    bookingId: json["booking_id"],
    productId: json["product_id"],
    slug: json["slug"],
    comment: json["comment"],
    rating: json["rating"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "booking_id": bookingId,
    "product_id": productId,
    "slug": slug,
    "comment": comment,
    "rating": rating,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}



