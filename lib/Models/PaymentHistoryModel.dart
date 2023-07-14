// To parse this JSON data, do
//
//     final paymentHistoryModel = paymentHistoryModelFromJson(jsonString);

import 'dart:convert';

PaymentHistoryModelElement paymentHistoryModelFromJson(String str) => PaymentHistoryModelElement.fromJson(json.decode(str));

String PaymentHistoryModelElementToJson(PaymentHistoryModel data) => json.encode(data.toJson());

class PaymentHistoryModelElement {
  PaymentHistoryModelElement({
    this.paymentHistoryModel,
  });

  List<PaymentHistoryModelElement>? paymentHistoryModel;

  factory PaymentHistoryModelElement.fromJson(Map<String, dynamic> json) => PaymentHistoryModelElement(
    paymentHistoryModel: List<PaymentHistoryModelElement>.from(json["PaymentHistoryModel"].map((x) => PaymentHistoryModelElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "PaymentHistoryModel": List<dynamic>.from(paymentHistoryModel!.map((x) => x.toJson())),
  };
}

class PaymentHistoryModel {
  PaymentHistoryModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.chargeAmount,
    this.netAmount,
    this.platformFee,
    this.sender,
    this.receiver,
    this.createdAt,
  });

  int? id;
  int? senderId;
  int? receiverId;
  String? chargeAmount;
  String? netAmount;
  String? platformFee;
  Receiver? sender;
  Receiver? receiver;
  DateTime? createdAt;

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    chargeAmount: json["charge_amount"],
    netAmount: json["net_amount"],
    platformFee: json["platform_fee"],
    sender: Receiver.fromJson(json["sender"]),
    receiver: Receiver.fromJson(json["receiver"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "charge_amount": chargeAmount,
    "net_amount": netAmount,
    "platform_fee": platformFee,
    "sender": sender?.toJson(),
    "receiver": receiver?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Receiver {
  Receiver({
    this.id,
    this.name,
    this.slug,
    this.email,
    this.mobileNo,
    this.imageUrl,
  });

  int? id;
  String? name;
  String? slug;
  String? email;
  String? mobileNo;
  String? imageUrl;

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "email": email,
    "mobile_no": mobileNo,
    "image_url": imageUrl,
  };
}
