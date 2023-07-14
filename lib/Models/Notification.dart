// To parse this JSON data, do
//
//     final notificationMain = notificationMainFromJson(jsonString);

import 'dart:convert';

NotificationMain? notificationMainFromJson(String str) => NotificationMain.fromJson(json.decode(str));

String notificationMainToJson(NotificationMain? data) => json.encode(data!.toJson());

class NotificationMain {
  NotificationMain({
    this.notfi,
  });

  List<Notfi?>? notfi;

  factory NotificationMain.fromJson(Map<String, dynamic> json) => NotificationMain(
    notfi: json["Notfi"] == null ? [] : List<Notfi?>.from(json["Notfi"]!.map((x) => Notfi.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Notfi": notfi == null ? [] : List<dynamic>.from(notfi!.map((x) => x!.toJson())),
  };
}

class Notfi {
  Notfi({
    this.id,
    this.uniqueId,
    this.identifier,
    this.actorId,
    this.targetId,
    this.module,
    this.moduleId,
    this.referenceId,
    this.referenceModule,
    this.title,
    this.description,
    this.webRedirectLink,
    this.isRead,
    this.isView,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.actorName,
    this.actorEmail,
    this.actorImageUrl,
  });

  int? id;
  String? uniqueId;
  String? identifier;
  int? actorId;
  int? targetId;
  String? module;
  int? moduleId;
  int? referenceId;
  String? referenceModule;
  String? title;
  String? description;
  String? webRedirectLink;
  String? isRead;
  String? isView;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? actorName;
  String? actorEmail;
  String? actorImageUrl;

  factory Notfi.fromJson(Map<String, dynamic> json) => Notfi(
    id: json["id"],
    uniqueId: json["unique_id"],
    identifier: json["identifier"],
    actorId: json["actor_id"],
    targetId: json["target_id"],
    module: json["module"],
    moduleId: json["module_id"],
    referenceId: json["reference_id"],
    referenceModule: json["reference_module"],
    title: json["title"],
    description: json["description"],
    webRedirectLink: json["web_redirect_link"],
    isRead: json["is_read"],
    isView: json["is_view"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
    actorName: json["actor_name"],
    actorEmail: json["actor_email"],
    actorImageUrl: json["actor_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "identifier": identifier,
    "actor_id": actorId,
    "target_id": targetId,
    "module": module,
    "module_id": moduleId,
    "reference_id": referenceId,
    "reference_module": referenceModule,
    "title": title,
    "description": description,
    "web_redirect_link": webRedirectLink,
    "is_read": isRead,
    "is_view": isView,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "actor_name": actorName,
    "actor_email": actorEmail,
    "actor_image_url": actorImageUrl,
  };
}
