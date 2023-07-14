// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);

import 'dart:convert';

Banner bannerFromJson(String str) => Banner.fromJson(json.decode(str));

String bannerToJson(Banner data) => json.encode(data.toJson());

class Banner {
  Banner({
    this.bannerobj,
  });

  List<Bannerobj>? bannerobj;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    bannerobj: List<Bannerobj>.from(json["bannerobj"].map((x) => Bannerobj.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bannerobj": List<dynamic>.from(bannerobj!.map((x) => x.toJson())),
  };
}

class Bannerobj {
  Bannerobj({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.imageUrl,
  });

  int? id;
  String? slug;
  String? title;
  String? description;
  String? imageUrl;

  factory Bannerobj.fromJson(Map<String, dynamic> json) => Bannerobj(
    id: json["id"],
    slug: json["slug"],
    title: json["title"],
    description: json["description"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "title": title,
    "description": description,
    "image_url": imageUrl,
  };
}
