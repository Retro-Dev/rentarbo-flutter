class CardDetailsModel {
  int? id;
  int? userId;
  String? slug;
  String? cardId;
  String? brand;
  String? last4Digit;
  String? isDefault;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  CardDetailsModel(
      {this.id,
        this.userId,
        this.slug,
        this.cardId,
        this.brand,
        this.last4Digit,
        this.isDefault,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  CardDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    slug = json['slug'];
    cardId = json['card_id'];
    brand = json['brand'];
    last4Digit = json['last_4_digit'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['slug'] = this.slug;
    data['card_id'] = this.cardId;
    data['brand'] = this.brand;
    data['last_4_digit'] = this.last4Digit;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}