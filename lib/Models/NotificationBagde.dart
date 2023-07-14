// To parse this JSON data, do
//
//     final notificationBadge = notificationBadgeFromJson(jsonString);

import 'dart:convert';

NotificationBadge notificationBadgeFromJson(String str) => NotificationBadge.fromJson(json.decode(str));

String notificationBadgeToJson(NotificationBadge data) => json.encode(data.toJson());

class NotificationBadge {
  NotificationBadge({
     this.unreadNoti,
     this.message,
     this.pagination,
  });

  List<UnreadNoti>? unreadNoti;
  String? message;
  Pagination? pagination;

  factory NotificationBadge.fromJson(Map<String, dynamic> json) => NotificationBadge(
    unreadNoti: List<UnreadNoti>.from(json["data"].map((x) => UnreadNoti.fromJson(x))),
    message: json["message"],
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(unreadNoti!.map((x) => x.toJson())),
    "message": message,
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  Pagination({
     this.links,
     this.meta,
  });

  Links? links;
  Meta? meta;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
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
     this.currentPage,
     this.from,
     this.lastPage,
     this.to,
     this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  int? to;
  int? total;

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

class UnreadNoti {
  UnreadNoti({
     this.unread,
  });

  int? unread;

  factory UnreadNoti.fromJson(Map<String, dynamic> json) => UnreadNoti(
    unread: json["unread"],
  );

  Map<String, dynamic> toJson() => {
    "unread": unread,
  };
}
