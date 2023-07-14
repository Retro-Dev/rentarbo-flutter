// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

CategoryObject categoryFromJson(String str) => CategoryObject.fromJson(json.decode(str));

String categoryToJson(CategoryObject data) => json.encode(data.toJson());

class CategoryObject {
  CategoryObject({
    this.categoryObj,
  });

  List<CategoryObj>? categoryObj;

  factory CategoryObject.fromJson(Map<String, dynamic> json) => CategoryObject(
    categoryObj: List<CategoryObj>.from(json["categoryObj"].map((x) => CategoryObj.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryObj": List<dynamic>.from(categoryObj!.map((x) => x.toJson())),
  };
}

class CategoryObj {
  CategoryObj({
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

  factory CategoryObj.fromJson(Map<String, dynamic> json) => CategoryObj(
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
