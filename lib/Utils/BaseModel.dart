// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';


BaseModel baseModelFromJson(String str) => BaseModel.fromJson(json.decode(str));

String baseModelToJson(BaseModel data) => json.encode(data.toJson());

class BaseModel {
  BaseModel({
    required this.code,
    required this.message,
    required this.pagination,
    required this.data
  });

  int code;
  String? message;
  Pagination? pagination;
  dynamic data;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
    code: json["code"],
    message: json["message"],
    data: json["data"],
    pagination: json["pagination"]!=null?Pagination.fromJson(json["pagination"]):null,
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data" : data,
    "pagination": pagination?.toJson(),
  };
}
class Pagination {
  Pagination({
    required this.links,
    required this.meta,
  });

  Links links;
  Meta meta;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links.toJson(),
    "meta": meta.toJson(),
  };
}

class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  dynamic first;
  dynamic last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.to,
    required this.total,
  });

  int currentPage;
  int? from;
  int lastPage;
  int? to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "to": to,
    "total": total,
  };
}