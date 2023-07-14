// To parse this JSON data, do
//
//     final ads = adsFromJson(jsonString);

import 'dart:convert';

Ads adsFromJson(String str) => Ads.fromJson(json.decode(str));

String adsToJson(Ads data) => json.encode(data.toJson());

class Ads {
  Ads({
    this.adsObj,
  });

  List<AdsObj>? adsObj;

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
    adsObj: List<AdsObj>.from(json["AdsObj"].map((x) => AdsObj.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AdsObj": List<dynamic>.from(adsObj!.map((x) => x.toJson())),
  };
}

class AdsObj {
  AdsObj({
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
    this.pendingRequest,
    this.category,
    this.owner,
    this.media,
    this.is_approved,
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
  dynamic sellPrice;
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
  int? pendingRequest;
  CategoryAds? category;
  CategoryAds? owner;
  List<Media?>? media;
  int? is_approved;

  factory AdsObj.fromJson(Map<String, dynamic> json) => AdsObj(
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
    is_approved :  json["is_approved"],
    pendingRequest: json["pending_request"],
    category: CategoryAds.fromJson(json["category"]),
    owner: CategoryAds.fromJson(json["owner"]),
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
    "pending_request": pendingRequest,
    "category": category?.toJson(),
    "owner": owner?.toJson(),
    "is_approved" : is_approved,
    "media": List<dynamic>.from(media!.map((x) => x?.toJson())),
  };
}

class CategoryAds {
  CategoryAds({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
    // this.blurImage,
  });

  int? id;
  String? name;
  String? slug;
  String? description;
  String? imageUrl;
  // String? blurImage;

  factory CategoryAds.fromJson(Map<String, dynamic> json) => CategoryAds(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"] == null ? null : json["description"],
    imageUrl: json["image_url"],
    // blurImage: json["blur_image"] == null ? null : json["blur_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description == null ? null : description,
    "image_url": imageUrl,
    // "blur_image": blurImage == null ? null : blurImage,
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
