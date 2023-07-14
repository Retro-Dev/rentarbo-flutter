// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    this.reviewData,
  });

  List<ReviewDatum>? reviewData;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    reviewData: List<ReviewDatum>.from(json["ReviewData"].map((x) => ReviewDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ReviewData": List<dynamic>.from(reviewData!.map((x) => x.toJson())),
  };
}

class ReviewDatum {
  ReviewDatum({
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
    this.user,
    this.product,
  });

  int? id;
  int? userId;
  int? bookingId;
  int? productId;
  String? slug;
  String? comment;
  int? rating;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Product? product;

  factory ReviewDatum.fromJson(Map<String, dynamic> json) => ReviewDatum(

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
    user: User.fromJson(json["user"]),
    product: Product.fromJson(json["product"]),
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
    "user": user?.toJson(),
    "product": product?.toJson(),
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
    // this.tags,
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
    this.status,
    this.rating,
    this.reviews,
    this.isApproved,
    this.isSell,
    this.isRent,
    this.sellStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  int? userId;
  int? categoryId;
  String? name;
  String? slug;
  String? description;
  // String? tags;
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
  int? status;
  dynamic rating;
  String? reviews;
  int? isApproved;
  int? isSell;
  int? isRent;
  int? sellStatus;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    // tags: json["tags"],
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
    status: json["status"],
    rating: json["rating"],
    reviews: json["reviews"],
    isApproved: json["is_approved"],
    isSell: json["is_sell"],
    isRent: json["is_rent"],
    sellStatus: json["sell_status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "name": name,
    "slug": slug,
    "description": description,
    // "tags": tags,
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
    "status": status,
    "rating": rating,
    "reviews": reviews,
    "is_approved": isApproved,
    "is_sell": isSell,
    "is_rent": isRent,
    "sell_status": sellStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class User {
  User({
    this.id,
    this.userGroupId,
    this.userType,
    this.name,
    this.firstName,
    this.lastName,
    this.username,
    this.slug,
    this.email,
    this.mobileNo,
    this.password,
    this.imageUrl,
    this.blurImage,
    this.status,
    this.isEmailVerify,
    this.emailVerifyAt,
    this.isMobileVerify,
    this.mobileVerifyAt,
    this.country,
    this.city,
    this.state,
    this.zipcode,
    this.address,
    this.latitude,
    this.longitude,
    this.onlineStatus,
    this.mobileOtp,
    this.emailOtp,
    this.gatewayCustomerId,
    this.gatewayConnectId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isLogin,
  });

  int? id;
  int? userGroupId;
  String? userType;
  String? name;
  String? firstName;
  String? lastName;
  String? username;
  String? slug;
  String? email;
  String? mobileNo;
  String? password;
  String? imageUrl;
  String? blurImage;
  String? status;
  dynamic isEmailVerify;
  dynamic emailVerifyAt;
  String? isMobileVerify;
  dynamic mobileVerifyAt;
  dynamic country;
  dynamic city;
  dynamic state;
  dynamic zipcode;
  dynamic address;
  String? latitude;
  String? longitude;
  String? onlineStatus;
  dynamic mobileOtp;
  dynamic emailOtp;
  String? gatewayCustomerId;
  String? gatewayConnectId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  int? isLogin;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userGroupId: json["user_group_id"],
    userType: json["user_type"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    slug: json["slug"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    password: json["password"],
    imageUrl: json["image_url"],
    blurImage: json["blur_image"],
    status: json["status"],
    isEmailVerify: json["is_email_verify"],
    emailVerifyAt: json["email_verify_at"],
    isMobileVerify: json["is_mobile_verify"],
    mobileVerifyAt: json["mobile_verify_at"],
    country: json["country"],
    city: json["city"],
    state: json["state"],
    zipcode: json["zipcode"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    onlineStatus: json["online_status"],
    mobileOtp: json["mobile_otp"],
    emailOtp: json["email_otp"],
    gatewayCustomerId: json["gateway_customer_id"],
    gatewayConnectId: json["gateway_connect_id"],
    createdAt: json["created_at"],
    updatedAt:json["updated_at"],
    deletedAt: json["deleted_at"],
    isLogin: json["is_login"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_group_id": userGroupId,
    "user_type": userType,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "slug": slug,
    "email": email,
    "mobile_no": mobileNo,
    "password": password,
    "image_url": imageUrl,
    "blur_image": blurImage,
    "status": status,
    "is_email_verify": isEmailVerify,
    "email_verify_at": emailVerifyAt?.toIso8601String(),
    "is_mobile_verify": isMobileVerify,
    "mobile_verify_at": mobileVerifyAt?.toIso8601String(),
    "country": country,
    "city": city,
    "state": state,
    "zipcode": zipcode,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "online_status": onlineStatus,
    "mobile_otp": mobileOtp,
    "email_otp": emailOtp,
    "gateway_customer_id": gatewayCustomerId,
    "gateway_connect_id": gatewayConnectId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "is_login": isLogin,
  };
}
