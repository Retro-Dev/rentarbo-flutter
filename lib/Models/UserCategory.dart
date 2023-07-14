// To parse this JSON data, do
//
//     final userCategory = userCategoryFromJson(jsonString);

import 'dart:convert';

UserCategory userCategoryFromJson(String str) => UserCategory.fromJson(json.decode(str));

String userCategoryToJson(UserCategory data) => json.encode(data.toJson());

class UserCategory {
  UserCategory({
    this.userCategoryObj,
  });

  List<UserCategoryObj>? userCategoryObj;

  factory UserCategory.fromJson(Map<String, dynamic> json) => UserCategory(
    userCategoryObj: List<UserCategoryObj>.from(json["userCategoryObj"].map((x) => UserCategoryObj.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userCategoryObj": List<dynamic>.from(userCategoryObj!.map((x) => x.toJson())),
  };
}

class UserCategoryObj {
  UserCategoryObj({
    this.id,
    this.userId,
    this.categoryId,
    this.category,
  });

  int? id;
  int? userId;
  int? categoryId;
  CategoryUser? category;

  factory UserCategoryObj.fromJson(Map<String, dynamic> json) => UserCategoryObj(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    category: CategoryUser.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "category": category!.toJson(),
  };
}

class CategoryUser {
  CategoryUser({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
  });

  int? id;
  String? name;
  String? slug;
  String? description;
  String? imageUrl;

  factory CategoryUser.fromJson(Map<String, dynamic> json) => CategoryUser(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "image_url": imageUrl,
  };
}
