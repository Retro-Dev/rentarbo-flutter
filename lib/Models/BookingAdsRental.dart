// To parse this JSON data, do
//
//     final bookingAdsRental = bookingAdsRentalFromJson(jsonString);

import 'dart:convert';

BookingAdsRental bookingAdsRentalFromJson(String str) => BookingAdsRental.fromJson(json.decode(str));

String bookingAdsRentalToJson(BookingAdsRental data) => json.encode(data.toJson());

class BookingAdsRental {
  BookingAdsRental({
    this.bookingData,
  });

  List<BookingDatum>? bookingData;

  factory BookingAdsRental.fromJson(Map<String, dynamic> json) => BookingAdsRental(
    bookingData: List<BookingDatum>.from(json["bookingData"].map((x) => BookingDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bookingData": List<dynamic>.from(bookingData!.map((x) => x.toJson())),
  };
}

class BookingDatum {
  BookingDatum({
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
    this.returnedAt,
    this.returned,
    this.returnConfirmed,
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
  String? rentarName;
  String? phoneNo;
  String? details;
  int? duration;
  String? totalCharges;
  String? adminTax;
  String? netAmount;
  String? demoHosting;
  String? bookingStatus;
  int? is_repost;
  DateTime? returnedAt;
  String? returned;
  DateTime? returnConfirmed;
  DateTime? createdAt;
  Owner? rentar;
  Owner? owner;
  Product? product;

  factory BookingDatum.fromJson(Map<String, dynamic> json) => BookingDatum(


    id: json["id"] != null ? json["id"] : 1 ,
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
    returnedAt: DateTime.parse(json["returned_at"]),
    returned: json["returned"],
    returnConfirmed: DateTime.parse(json["return_confirmed"]),
    createdAt: DateTime.parse(json["created_at"]),
    rentar: Owner.fromJson(json["rentar"]),
    owner: Owner.fromJson(json["owner"]),
    product: Product.fromJson(json["product"]),
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
    "is_repost" : is_repost,
    "returned_at": returnedAt?.toIso8601String(),
    "returned": returned,
    "return_confirmed": returnConfirmed?.toIso8601String(),
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
  });

  int? id;
  String? name;
  String? slug;
  String? imageUrl;
  String? blurImage;
  String? description;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
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

class Product {
  Product({
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
  Owner? category;
  List<Media>? media;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
