// To parse this JSON data, do
//
//     final sellBookingDetails = sellBookingDetailsFromJson(jsonString);

import 'dart:convert';

SellBookingDetails sellBookingDetailsFromJson(String str) => SellBookingDetails.fromJson(json.decode(str));

String sellBookingDetailsToJson(SellBookingDetails data) => json.encode(data.toJson());

class SellBookingDetails {
  SellBookingDetails({
    this.data,
  });

  Data? data;

  factory SellBookingDetails.fromJson(Map<String, dynamic> json) => SellBookingDetails(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.productOwnerId,
    this.slug,
    this.productId,
    this.rname,
    this.phoneNumber,
    this.additionalInfo,
    this.totalCharges,
    this.adminTax,
    this.netAmount,
    this.demoHosting,
    this.sellStatus,
    this.pickedUpStatus,
    this.pickedUp,
    this.deliveredStatus,
    this.deliveredAt,
    this.createdAt,
    this.rentar,
    this.owner,
    this.product,
  });

  int? id;
  int? userId;
  int? productOwnerId;
  String? slug;
  int? productId;
  dynamic rname;
  String? phoneNumber;
  String? additionalInfo;
  dynamic totalCharges;
  dynamic adminTax;
  dynamic netAmount;
  dynamic demoHosting;
  String? sellStatus;
  String? pickedUpStatus;
  dynamic pickedUp;
  String? deliveredStatus;
  dynamic deliveredAt;
  DateTime? createdAt;
  Owner? rentar;
  Owner? owner;
  SellDetailProduct? product;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    productOwnerId: json["product_owner_id"],
    slug: json["slug"],
    productId: json["product_id"],
    rname: json["rname"],
    phoneNumber: json["phone_number"],
    additionalInfo: json["additional_info"],
    totalCharges: json["total_charges"],
    adminTax: json["admin_tax"],
    netAmount: json["net_amount"],
    demoHosting: json["demo_hosting"],
    sellStatus: json["sell_status"],
    pickedUpStatus: json["picked_up_status"],
    pickedUp: json["picked_up"],
    deliveredStatus: json["delivered_status"],
    deliveredAt: json["delivered_at"],
    createdAt: DateTime.parse(json["created_at"]),
    rentar: Owner.fromJson(json["rentar"]),
    owner: Owner.fromJson(json["owner"]),
    product: SellDetailProduct.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_owner_id": productOwnerId,
    "slug": slug,
    "product_id": productId,
    "rname": rname,
    "phone_number": phoneNumber,
    "additional_info": additionalInfo,
    "total_charges": totalCharges,
    "admin_tax": adminTax,
    "net_amount": netAmount,
    "demo_hosting": demoHosting,
    "sell_status": sellStatus,
    "picked_up_status": pickedUpStatus,
    "picked_up": pickedUp,
    "delivered_status": deliveredStatus,
    "delivered_at": deliveredAt,
    "created_at": createdAt?.toIso8601String(),
    "rentar": rentar?.toJson(),
    "owner": owner?.toJson(),
    "product": product?.toJson(),
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
    mobileNo: json["mobile_no"],
    imageUrl: json["image_url"],
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

class SellDetailProduct {
  SellDetailProduct({
    this.id,
    this.userId,
    this.categoryId,
    this.name,
    this.slug,
    this.description,
    this.tags,
    this.rentType,
    this.rentCharges,
    this.sellPrice,
    this.pickUpLocationAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropLocationAddress,
    this.dropLat,
    this.dropLng,
    this.ssn,
    this.idCard,
    this.drivingLicense,
    this.hostingDemos,
    this.rating,
    this.reviews,
    this.isSell,
    this.isRent,
    this.sellStatus,
    this.status,
    this.pendingRequest,
    this.category,
    this.media,
  });

  int? id;
  int? userId;
  int? categoryId;
  String? name;
  String? slug;
  String? description;
  List<String>? tags;
  String? rentType;
  String? rentCharges;
  String? sellPrice;
  String? pickUpLocationAddress;
  String? pickupLat;
  String? pickupLng;
  String? dropLocationAddress;
  String? dropLat;
  String? dropLng;
  String? ssn;
  String? idCard;
  String? drivingLicense;
  String? hostingDemos;
  dynamic rating;
  String? reviews;
  int? isSell;
  int? isRent;
  int? sellStatus;
  int? status;
  int? pendingRequest;
  Owner? category;
  List<Media>? media;

  factory SellDetailProduct.fromJson(Map<String, dynamic> json) => SellDetailProduct(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    rentType: json["rent_type"],
    rentCharges: json["rent_charges"],
    sellPrice: json["sell_price"],
    pickUpLocationAddress: json["pick_up_location_address"],
    pickupLat: json["pickup_lat"],
    pickupLng: json["pickup_lng"],
    dropLocationAddress: json["drop_location_address"],
    dropLat: json["drop_lat"],
    dropLng: json["drop_lng"],
    ssn: json["ssn"],
    idCard: json["id_card"],
    drivingLicense: json["driving_license"],
    hostingDemos: json["hosting_demos"],
    rating: json["rating"],
    reviews: json["reviews"],
    isSell: json["is_sell"],
    isRent: json["is_rent"],
    sellStatus: json["sell_status"],
    status: json["status"],
    pendingRequest: json["pending_request"],
    category: Owner.fromJson(json["category"]),
    media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "name": name,
    "slug": slug,
    "description": description,
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "rent_type": rentType,
    "rent_charges": rentCharges,
    "sell_price": sellPrice,
    "pick_up_location_address": pickUpLocationAddress,
    "pickup_lat": pickupLat,
    "pickup_lng": pickupLng,
    "drop_location_address": dropLocationAddress,
    "drop_lat": dropLat,
    "drop_lng": dropLng,
    "ssn": ssn,
    "id_card": idCard,
    "driving_license": drivingLicense,
    "hosting_demos": hostingDemos,
    "rating": rating,
    "reviews": reviews,
    "is_sell": isSell,
    "is_rent": isRent,
    "sell_status": sellStatus,
    "status": status,
    "pending_request": pendingRequest,
    "category": category?.toJson(),
    "media": List<dynamic>.from(media!.map((x) => x.toJson())),
  };
}

class Media {
  Media({
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

  factory Media.fromJson(Map<String, dynamic> json) => Media(
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
    "created_at": createdAt?.toIso8601String(),
  };
}
